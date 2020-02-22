//
//  MCMapCanvas.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class MCMapCanvas: MKMapView {
	
	/// The spacing between the palette and their superview as well as between the children tool stacks
	private static let toolPaletteInset: CGFloat = 10
	
	/// The general tools palette which is at the top left corner of the canvas
	let generalToolsPalette	= MCToolPalette(axis: .horizontal)
	
	/// The drawing tools palette which is at the leading edge of the canvas and holds all drawing tools
	let drawingToolsPalette	= MCToolPalette(axis: .vertical)
	
	/// The info tool stack which appears each time its told to display a text. It is located at the top edge of the canvas
	let infoToolStack		= MCSlidingInfoToolStack(forAxis: .horizontal)
	
	/// The currently selected drawing tool
	var selectedDrawingTool: MCMapCanvas.DrawingTool = .pointer
	
	/// The different drawing tools available in the map canvas
	enum DrawingTool {
		
		/// The pointer tool is used to select entities.
		case pointer
		
		/// The polyline tool is used to draw a polyline.
		case polyline
		
		/// The polygon tool is used to draw a polygon
		case polygon
		
		/// The measure tool is used to measure the distance between two points
		case measure
	}
	
	init() {
		super.init(frame: .zero)
		autolayout()
		
		//
		// Configure the different palettes and overlay
		configureGeneralToolsPalette()
		configureDrawingToolsPalette()
		configureInfoToolStack()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Configure the general tools palette in the canvas
	func configureGeneralToolsPalette() -> Void {
		generalToolsPalette.spacing = MCMapCanvas.toolPaletteInset
		
		addSubview(generalToolsPalette)
		generalToolsPalette.topEdgeToSafeSuperview()
		generalToolsPalette.leadingEdgeToSafeSuperview(withInset: MCMapCanvas.toolPaletteInset)
		
		let closeToolStack = MCCloseToolStack(forAxis: generalToolsPalette.axis)
		generalToolsPalette.addToolStack(closeToolStack)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			closeToolStack.showInfoLabel(withText: "test")
		}
		
		generalToolsPalette.reset()
	}
	
	/// Configure the drawing tools palette in the canvas
	func configureDrawingToolsPalette() -> Void {
		drawingToolsPalette.spacing = MCMapCanvas.toolPaletteInset
		
		addSubview(drawingToolsPalette)
		drawingToolsPalette.leadingEdgeToSafeSuperview(withInset: MCMapCanvas.toolPaletteInset)
		drawingToolsPalette.centerVertically()
		
		let drawingToolStack = MCToolStack(forAxis: drawingToolsPalette.axis)
		drawingToolStack.addItem(MCToolStackItem(type: .drawingTool(type: .pointer), isDefault: true))
		drawingToolStack.addItem(MCToolStackItem(type: .drawingTool(type: .polyline)))
		drawingToolStack.addItem(MCToolStackItem(type: .drawingTool(type: .polygon)))
		drawingToolStack.addItem(MCToolStackItem(type: .drawingTool(type: .measure)))
		drawingToolsPalette.addToolStack(drawingToolStack)
		
		drawingToolsPalette.reset()
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
}
