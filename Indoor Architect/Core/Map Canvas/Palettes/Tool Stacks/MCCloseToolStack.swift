//
//  MCCloseToolStack.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCCloseToolStack: MCToolStack {
	
	private static let animationSpeed: TimeInterval = 0.1
	
	let closeItem = MCCloseToolStackItem()
	let infoLabel = MCLabelToolStackItem()
	
	init() {
		super.init(forAxis: .horizontal)
		
		closeItem.stack = self
		infoLabel.stack = self
		
		addItem(closeItem)
		addItem(infoLabel)
		
		infoLabel.isUserInteractionEnabled = false
		infoLabel.isHidden = true
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showInfoLabel(withText text: String) -> Void {
		infoLabel.setTitle(text)
		layoutIfNeeded()
		
		UIView.animate(withDuration: MCCloseToolStack.animationSpeed) {
			self.infoLabel.isHidden = false
		}
	}
	
	func hideInfoLabel() -> Void {
		UIView.animate(withDuration: MCCloseToolStack.animationSpeed) {
			self.infoLabel.isHidden = true
		}
	}
}
