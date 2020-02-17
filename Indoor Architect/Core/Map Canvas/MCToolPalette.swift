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
	
	func addToolStack(_ toolStack: MCToolStack) -> Void {
		addArrangedSubview(toolStack)
	}
	
	func removeToolStack(_ toolStack: MCToolStack) -> Void {
		removeArrangedSubview(toolStack)
	}
}
