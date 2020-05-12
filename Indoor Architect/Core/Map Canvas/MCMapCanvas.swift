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
	
	var closeToolStack			= MCToolStack(forAxis: .horizontal)
	var coordinateToolStack		= MCCoordinateToolStack()
	var infoToolStack			= MCSlidingInfoToolStack()
	var drawingToolStack		= MCToolStack(forAxis: .vertical)
	var drawingConfirmToolStack = MCToolStack(forAxis: .vertical)

	
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
	
	var polygonAssembler: MCPolygonAssembler?
	
	var distanceRuler = MCDistanceRuler()
	
	var panGestureRecognizer: InitialPanGestureRecognizer!
	
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
		
		panGestureRecognizer = InitialPanGestureRecognizer(target: self, action: #selector(didPanMap))
		addGestureRecognizer(panGestureRecognizer)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Configures the base overlay for the map canvas
	func configureToolStackOverlay() -> Void {
		
		//
		// Set the reference to the canvas for all tool stacks
		closeToolStack.canvas			= self
		coordinateToolStack.canvas		= self
		infoToolStack.canvas			= self
		drawingToolStack.canvas			= self
		drawingConfirmToolStack.canvas	= self
		
		closeToolStack.addItem(MCCloseToolStackItem(self))
		
		//
		// Add all drawing tool stack items to the drawing tool stack
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .pointer, isDefault: true))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .anchor))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .polyline))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .polygon))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .measure))
		
		//
		// Add the drawing confirm button for the tool stack
		drawingConfirmToolStack.addItem(MCDrawingConfirmToolStackItem(actionType: .confirm))
		drawingConfirmToolStack.addItem(MCDrawingConfirmToolStackItem(actionType: .discard))
		drawingConfirmToolStack.isHidden = true
		
		let topEdgePalette			= UIStackView(arrangedSubviews: [closeToolStack, coordinateToolStack])
		topEdgePalette.axis			= .horizontal
		topEdgePalette.spacing		= Spacing.mapCanvasToolPalette
		
		let leadingEdgePalette		= UIStackView(arrangedSubviews: [drawingToolStack, drawingConfirmToolStack])
		leadingEdgePalette.axis		= .vertical
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
		infoToolStack.display(text: "\(drawingTool)".capitalized, withLabel: "Tool")
		
		discardActiveShapeAssembler()
		
		controller.mapCanvas(self, didSwitch: drawingTool)
	}

	@objc func didTapMap(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
		let point = gestureRecognizer.location(in: self)
		let coordinate = self.convert(point, toCoordinateFrom: self)
		
		controller.mapCanvas(self, didTapOn: coordinate, with: selectedDrawingTool)
	}
	
	@objc func didPanMap(_ gestureRecognizer: InitialPanGestureRecognizer) -> Void {
		if selectedDrawingTool == .measure {
			distanceRuler.makeUsingGesture(recognizer: gestureRecognizer)
		}
	}
	
	func renderFeatures() -> Void {
		removeOverlays(overlays)
		removeAnnotations(annotations)
		
		distanceRuler.invalidate()
		
		//
		// Render anchors
		Application.currentProject.imdfArchive.anchors.forEach { self.addAnnotation(IMDFAnchorAnnotation(coordinate: $0.getCoordinates(), anchor: $0)) }
		
		//
		// Render units
		Application.currentProject.imdfArchive.units.compactMap({ IMDFUnitOverlay.from(unit: $0) }).forEach({ self.addOverlay($0) })
	}
	
	/// Adds a new anchor annotation to the project
	/// - Parameter geometry: The point geometry of the anchor
	func addAnchor(_ geometry: [MKShape & MKGeoJSONObject]) -> Void {
		let uuid = Application.currentProject.getUnusedGlobalUuid()
		
		let anchor = Anchor(withIdentifier: uuid, properties: Anchor.Properties(), geometry: geometry, type: .anchor)
		Application.currentProject.imdfArchive.anchors.append(anchor)
		try? Application.currentProject.imdfArchive.save(.anchor)
		
		addAnnotation(IMDFAnchorAnnotation(coordinate: anchor.getCoordinates(), anchor: anchor))
	}
	
	/// Adds a new unit to the project representing a polygonal feature
	/// - Parameter geometry: The polygonal geometry of the unit
	func addUnit(_ geometry: [MKShape & MKGeoJSONObject]) -> Void {
		let uuid = Application.currentProject.getUnusedGlobalUuid()
		
		let unit = Unit(withIdentifier: uuid, properties: Unit.Properties(), geometry: geometry, type: .unit)
		Application.currentProject.imdfArchive.units.append(unit)
		try? Application.currentProject.imdfArchive.save(.unit)
		
		if let overlay = IMDFUnitOverlay.from(unit: unit) {
			addOverlay(overlay)
		}
	}
	
	func saveAndClose() -> Void {
		controller.dismiss(animated: true, completion: nil)
	}
	
	/// Returns the currently active shape assembler
	///
	/// This function can return `nil` if no shape assembler is currently active and awaiting further orders
	func getActiveShapeAssembler() -> MCShapeAssembler? {
		if let polygonAssembler = polygonAssembler {
			return polygonAssembler
		}
		
		return nil
	}
	
	func discardActiveShapeAssembler() -> Void {
		getActiveShapeAssembler()?.removeActiveOverlay()
		
		polygonAssembler = nil
		
		hideConfirmShapeButton()
	}
	
	func showConfirmShapeButton() -> Void {
		drawingConfirmToolStack.isHidden = false
	}
	
	func hideConfirmShapeButton() -> Void {
		drawingConfirmToolStack.isHidden = true
	}
}
