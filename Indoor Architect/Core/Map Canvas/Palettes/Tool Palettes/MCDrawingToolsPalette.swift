//
//  MCDrawingToolsPalette.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class MCDrawingToolsPalette: MCToolPalette {
	
	let drawingToolStack = MCToolStack(forAxis: .vertical)
	
	init() {
		super.init(axis: .vertical)
		
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .pointer, isDefault: true))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .polyline))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .polygon))
		drawingToolStack.addItem(MCDrawingToolStackItem(for: .measure))
		addToolStack(drawingToolStack)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
