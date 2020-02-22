//
//  MCToolPalette.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCToolPalette: UIStackView {
	
	init(axis: NSLayoutConstraint.Axis) {
		super.init(frame: .zero)
		autolayout()
		
		self.axis = axis
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Resets all tool stacks to its default values
	///
	/// When a canvas is closed and then reopened the user may have selected a different
	/// project, so the tools are resetted to its default values
	func reset() -> Void {
		arrangedSubviews.forEach { (subview) in
			if let toolStack = subview as? MCToolStack {
				toolStack.reset()
			}
		}
	}
	
	func addToolStack(_ toolStack: MCToolStack) -> Void {
		addArrangedSubview(toolStack)
	}
	
	func removeToolStack(_ toolStack: MCToolStack) -> Void {
		removeArrangedSubview(toolStack)
	}
}
