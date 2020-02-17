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
	
	private let toolPaletteInset: CGFloat = 10
	private var toolPalettes: [MCToolPalette] = []
	
	var selectedDrawingTool: MCMapCanvas.DrawingTool = .pointer
	
	enum DrawingTool {
		case pointer
		case polyline
		case polygon
		case measure
	}
	
	init() {
		super.init(frame: .zero)
		autolayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func switchDrawingTool(_ drawingTool: MCMapCanvas.DrawingTool) -> Void {
		selectedDrawingTool = drawingTool
	}
	
	func addToolPalette(_ toolPalette: MCToolPalette) -> Void {
		toolPalettes.append(toolPalette)
		toolPalette.spacing = toolPaletteInset
		addSubview(toolPalette)
		
		if toolPalette.axis == .horizontal {
			toolPalette.topEdgeToSafeSuperview(withInset: toolPaletteInset)
			toolPalette.leadingEdgeToSafeSuperview(withInset: toolPaletteInset)
		} else {
			toolPalette.leadingEdgeToSafeSuperview(withInset: toolPaletteInset)
			toolPalette.centerVertically()
		}
	}
}
