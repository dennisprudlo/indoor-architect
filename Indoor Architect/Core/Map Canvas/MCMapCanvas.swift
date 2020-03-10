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
}

class MCMapCanvas: MKMapView, MKMapViewDelegate {
	
	/// The spacing between the palette and their superview as well as between the children tool stacks
	private static let toolPaletteInset: CGFloat = 10
	
	/// The general tools palette which is at the top left corner of the canvas
	let toolPalette	= MCGeneralToolsPalette()
	
	/// The drawing tools palette which is at the leading edge of the canvas and holds all drawing tools
	let drawingToolPalette	= MCDrawingToolsPalette()
	
	/// The info tool stack which appears each time its told to display a text. It is located at the top edge of the canvas
	let infoToolStack		= MCSlidingInfoToolStack(forAxis: .horizontal)
	
	/// The currently selected drawing tool
	var selectedDrawingTool: MCMapCanvas.DrawingTool = .pointer
	
	/// The delegate for the map canvas events
	var drawingDelegate: MCMapCanvasDelegate?
	
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
	
	init() {
		super.init(frame: .zero)
		delegate = self
		autolayout()
		
		showsUserLocation = false
		showsTraffic = false
		
		//
		// Configure the different palettes and overlay
		configureGeneralToolsPalette()
		configureDrawingToolsPalette()
		configureInfoToolStack()
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMap)))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Configure the general tools palette in the canvas
	func configureGeneralToolsPalette() -> Void {
		toolPalette.spacing = MCMapCanvas.toolPaletteInset
		
		addSubview(toolPalette)
		toolPalette.topEdgeToSafeSuperview()
		toolPalette.leadingEdgeToSafeSuperview(withInset: MCMapCanvas.toolPaletteInset)
		toolPalette.reset()
	}
	
	/// Configure the drawing tools palette in the canvas
	func configureDrawingToolsPalette() -> Void {
		drawingToolPalette.spacing = MCMapCanvas.toolPaletteInset
		
		addSubview(drawingToolPalette)
		drawingToolPalette.leadingEdgeToSafeSuperview(withInset: MCMapCanvas.toolPaletteInset)
		drawingToolPalette.centerVertically()
		drawingToolPalette.reset()
	}
	
	/// Configure the info tool stack in the canvas
	func configureInfoToolStack() -> Void {
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
	}

	@objc func didTapMap(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
		let point = gestureRecognizer.location(in: self)
		let coordinate = self.convert(point, toCoordinateFrom: self)
		
		drawingDelegate?.mapCanvas(self, didTapOn: coordinate, with: selectedDrawingTool)
	}
}
