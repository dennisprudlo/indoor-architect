//
//  MapCanvasViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/15/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class MapCanvasViewController: UIViewController {

	static let shared		= MapCanvasViewController()
	
	let canvas				= MCMapCanvas()
	
	let leadingToolPalette	= MCToolPalette(axis: .vertical)
	let topToolPalette		= MCToolPalette(axis: .horizontal)
	
	var project: IMDFProject!
	
	let pointerTool = MCToolStackItem(type: .drawingTool(type: .pointer))
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.addSubview(canvas)
		canvas.edgesToSuperview()
		
		canvas.addToolPalette(leadingToolPalette)
		canvas.addToolPalette(topToolPalette)

		configureTopToolPalette()
		configureLeadingToolPalette()
	}
	
	func configureTopToolPalette() -> Void {
		let closeToolStack = MCToolStack(forAxis: topToolPalette.axis)
		closeToolStack.addItem(MCToolStackItem(type: .close))
		
		topToolPalette.addToolStack(closeToolStack)
		
		let testStack = MCToolStack(forAxis: topToolPalette.axis)
		testStack.addItem(MCToolStackItem(type: .custom, isDefault: true))
		testStack.addItem(MCToolStackItem(type: .custom))
		
		topToolPalette.addToolStack(testStack)
		topToolPalette.reset()
	}
	
	func configureLeadingToolPalette() -> Void {
		let toolStack = MCToolStack(forAxis: leadingToolPalette.axis)
		toolStack.addItem(MCToolStackItem(type: .drawingTool(type: .pointer), isDefault: true))
		toolStack.addItem(MCToolStackItem(type: .drawingTool(type: .polyline)))
		toolStack.addItem(MCToolStackItem(type: .drawingTool(type: .polygon)))
		toolStack.addItem(MCToolStackItem(type: .drawingTool(type: .measure)))
		
		leadingToolPalette.addToolStack(toolStack)
		leadingToolPalette.reset()
	}
	
	func present(forProject project: IMDFProject) -> Void {
		self.project = project
		self.modalPresentationStyle = .fullScreen
		topToolPalette.reset()
		leadingToolPalette.reset()
		canvas.switchDrawingTool(.pointer)
		Application.rootViewController.present(self, animated: true, completion: nil)
	}
}
