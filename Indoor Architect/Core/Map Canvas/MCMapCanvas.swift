//
//  MCMapCanvas.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

protocol MCMapCanvasDelegate {
	func mapCanvas(_ canvas: MCMapCanvas, didTapOn location: CLLocationCoordinate2D, with drawingTool: MCMapCanvas.DrawingTool) -> Void
	func mapCanvas(_ canvas: MCMapCanvas, didSwitch drawingTool: MCMapCanvas.DrawingTool) -> Void
}

class MCMapCanvas: MKMapView {
	
	/// The project which is being handles in the map
	var project: IMDFProject!
	
	var closeToolStack		= MCCloseToolStack()
	var coordinateToolStack	= MCCoordinateToolStack()
	var infoToolStack		= MCSlidingInfoToolStack()
	var drawingToolStack	= MCToolStack(forAxis: .vertical)

	
	/// The currently selected drawing tool
	var selectedDrawingTool: MCMapCanvas.DrawingTool = .pointer
	
	/// The delegate for the map canvas events
	var controller: (UIViewController & MCMapCanvasDelegate)!
	
	/// The different drawing tools available in the map canvas
	enum DrawingTool {
		
		/// The pointer tool is used to select entities.
		case pointer
		
		/// The anchor tool is used to create points/markers
		case anchor
		
		/// The polyline tool is used to draw a polyline.
		case polyline
		
		/// The polygon tool is used to draw a polygon
		case polygon
		
		/// The measure tool is used to measure the distance between two points
		case measure
	}
	
	var distanceRuler = MCDistanceRuler()
	
	var panGestureRecognizer: UIPanGestureRecognizer!
	
	init() {
		super.init(frame: .zero)
		autolayout()
		
		//
		// Disable distracting map information
		showsUserLocation		= false
		showsTraffic			= false
		pointOfInterestFilter	= MKPointOfInterestFilter(including: [
			.airport,
			.evCharger,
			.hospital,
			.nationalPark,
			.publicTransport
		])
		
		//
		// Configure the distance ruler component
		distanceRuler.canvas = self
		
		//
		// Configure the different palettes and overlay
		configureToolStackOverlay()
		
		//
		// Add custom gesture recognizer
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMap)))
		
		panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanMap))
		addGestureRecognizer(panGestureRecognizer)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Configures the base overlay for the map canvas
	func configureToolStackOverlay() -> Void {
		
		//
		// Set the reference to the canvas for all tool stacks
		closeToolStack.canvas		= self
		coordinateToolStack.canvas	= self
		drawingToolStack.canvas		= self
		infoToolStack.canvas		= self
		
		//
		// Add all drawing tool stack items to the drawing tool stack
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .pointer, isDefault: true))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .anchor))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .polyline))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .polygon))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .measure))
		
		let topEdgePalette			= UIStackView(arrangedSubviews: [closeToolStack, coordinateToolStack])
		topEdgePalette.spacing		= Spacing.mapCanvasToolPalette
		
		let leadingEdgePalette		= UIStackView(arrangedSubviews: [drawingToolStack])
		leadingEdgePalette.spacing	= Spacing.mapCanvasToolPalette
		
		topEdgePalette.autolayout()
		leadingEdgePalette.autolayout()
		
		addSubview(topEdgePalette)
		topEdgePalette.topEdgeToSafeSuperview()
		topEdgePalette.leadingEdgeToSafeSuperview(withInset: Spacing.mapCanvasToolPalette)
		
		addSubview(leadingEdgePalette)
		leadingEdgePalette.leadingEdgeToSafeSuperview(withInset: Spacing.mapCanvasToolPalette)
		leadingEdgePalette.centerVertically()
		
		//
		// Add the sliding info tool stack
		addSubview(infoToolStack)
		infoToolStack.centerHorizontally()
		infoToolStack.topConstraint				= infoToolStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
		infoToolStack.topConstraint?.isActive	= true
	}
	
	/// Switches the currently selected drawing tool
	/// - Parameters:
	///   - drawingTool: The drawing tool to switch to
	func switchDrawingTool(_ drawingTool: MCMapCanvas.DrawingTool) -> Void {
		selectedDrawingTool = drawingTool
		infoToolStack.display(text: "\(drawingTool)".capitalized, withLabel: "Drawing Tool")
		
		controller.mapCanvas(self, didSwitch: drawingTool)
	}

	@objc func didTapMap(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
		let point = gestureRecognizer.location(in: self)
		let coordinate = self.convert(point, toCoordinateFrom: self)
		
		controller.mapCanvas(self, didTapOn: coordinate, with: selectedDrawingTool)
	}
	
	@objc func didPanMap(_ gestureRecognizer: UIPanGestureRecognizer) -> Void {
		if selectedDrawingTool == .measure {
			distanceRuler.makeUsingGesture(recognizer: gestureRecognizer)
		}
	}
	
	func generateIMDFOverlays() -> Void {
		removeOverlays(overlays)
		removeAnnotations(annotations)
		
		distanceRuler.invalidate()
		
		//
		// Render anchors
		project.imdfArchive.anchors.forEach { self.addAnnotation(IMDFAnchorAnnotation(coordinate: $0.getCoordinates(), anchor: $0)) }
	}
	
	func addAnchor(_ geometry: [MKShape & MKGeoJSONObject]) -> Void {
		let uuid = project.imdfArchive.getUnusedGlobalUuid()
		let properties = Anchor.Properties(addressId: nil, unitId: nil)
		
		let anchor = Anchor(withIdentifier: uuid, properties: properties, geometry: geometry, type: .anchor)
		project.imdfArchive.anchors.append(anchor)
		
		if let geometry = anchor.geometry.first {
			addAnnotation(geometry)
		}
	}
	
	func saveAndClose() -> Void {
		closeToolStack.showInfoLabel(withText: "Saving...")
		
		try? project.save()
		try? project.imdfArchive.save(.anchor)

		closeToolStack.hideInfoLabel()
		
		controller.dismiss(animated: true, completion: nil)
	}
}
