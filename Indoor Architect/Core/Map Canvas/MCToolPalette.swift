//
//  MCToolPalette.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCToolPalette: UIStackView {

	private var toolStacks: [MCToolStack] = []
	
	init(axis: NSLayoutConstraint.Axis) {
		super.init(frame: .zero)
		autolayout()
		
		self.axis = axis
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func reset() -> Void {
		toolStacks.forEach { (toolStack) in
			toolStack.deselectAll()
			toolStack.selectDefault()
		}
	}
	
	func addToolStack(_ toolStack: MCToolStack) -> Void {
		addArrangedSubview(toolStack)
		toolStacks.append(toolStack)
	}
	
	func removeToolStack(_ toolStack: MCToolStack) -> Void {
		removeArrangedSubview(toolStack)
		toolStacks.removeAll { (arrayToolStack) -> Bool in
			return arrayToolStack == toolStack
		}
	}
}
