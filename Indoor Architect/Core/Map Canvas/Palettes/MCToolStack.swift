//
//  MCToolStack.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCToolStack: UIView {
	
	/// The amount of points the stackview has a margin to the tool stack
	private static let stackViewInset: CGFloat = 5
	
	/// The stack view that contains all controls as a `MCToolStackItem'`
	private let stackView = UIStackView()
	
	/// Defines whether the tool stack is currently performing a control switch animation
	var isPerformingAnimation: Bool = false
	
	/// The map canvas where the tool stack is in
	var canvas: MCMapCanvas!
	
	private var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
	
	init(forAxis axis: NSLayoutConstraint.Axis) {
		super.init(frame: .zero)
		autolayout()
		
		//
		// Make every overflow of the tool stack invisible
		visualEffectView.layer.masksToBounds = true
		
		//
		// Configure the stack view itself
		stackView.autolayout()
		stackView.axis = axis
		
		//
		// Add a dark visual effect view as a background
		addSubview(visualEffectView)
		visualEffectView.autolayout()
		visualEffectView.edgesToSuperview()
		
		layer.shadowColor	= UIColor.black.cgColor
		layer.shadowOpacity	= 0.1
		layer.shadowRadius	= 6
		layer.shadowOffset	= CGSize(width: 5, height: 5)
		
		//
		// Add the stack view to the superview
		addSubview(stackView)
		stackView.edgesToSuperview(withInsets: UIEdgeInsets(
			top:	MCToolStack.stackViewInset,
			left:	MCToolStack.stackViewInset,
			bottom:	MCToolStack.stackViewInset,
			right:	MCToolStack.stackViewInset
		))
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Adds a tool stack item to the tool stack
	/// - Parameter toolStackItem: The tool stack item to add
	func addItem(_ toolStackItem: MCToolStackItem) -> Void {
		stackView.addArrangedSubview(toolStackItem)
		toolStackItem.stack = self
	}
	
	/// Removes a tool stack item from the stack
	/// - Parameter toolStackItem: The tool stack item to remove
	func removeItem(_ toolStackItem: MCToolStackItem) -> Void {
		stackView.removeArrangedSubview(toolStackItem)
		toolStackItem.stack = nil
	}
	
	/// Deselects all tool stack items
	func deselectAll() -> Void {
		stackView.arrangedSubviews.forEach { (subview) in
			if let toolStackItem = subview as? MCToolStackItem {
				toolStackItem.setSelected(false)
			}
		}
	}
	
	/// Selects the default tool stack item
	func selectDefault() -> Void {
		stackView.arrangedSubviews.forEach { (subview) in
			if let toolStackItem = subview as? MCToolStackItem, toolStackItem.isDefault {
				toolStackItem.setSelected(true)
			}
		}
	}
	
	/// Gets the rectangle of the currently selected item
	func currentSelectedToolRect() -> CGRect? {
		var rectangle: CGRect?
		stackView.arrangedSubviews.forEach { (subview) in
			if let toolStackItem = subview as? MCToolStackItem, toolStackItem.isSelected {
				rectangle = toolStackItem.frame
			}
		}
		return rectangle
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		//
		// Sets the corner radius for the tool stack
		if stackView.axis == .horizontal {
			
			visualEffectView.layer.cornerRadius = frame.size.height / 2
		} else {
			visualEffectView.layer.cornerRadius = frame.size.width / 2
		}
	}
}
