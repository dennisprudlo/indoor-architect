//
//  MCToolStack.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCToolStack: UIView {
	
	private let inset: CGFloat = 5
	private var toolStackItems: [MCToolStackItem] = []
	private let stackView = UIStackView()
	
	init(forAxis axis: NSLayoutConstraint.Axis) {
		super.init(frame: .zero)
		autolayout()
		layer.masksToBounds = true
		stackView.autolayout()
		stackView.axis = axis
		
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
		addSubview(visualEffectView)
		visualEffectView.autolayout()
		visualEffectView.edgesToSuperview()
		
		addSubview(stackView)
		stackView.edgesToSuperview(withInsets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addItem(_ toolStackItem: MCToolStackItem) -> Void {
		stackView.addArrangedSubview(toolStackItem)
		toolStackItems.append(toolStackItem)
		
		toolStackItem.stack = self
	}
	
	func removeItem(_ toolStackItem: MCToolStackItem) -> Void {
		stackView.removeArrangedSubview(toolStackItem)
		toolStackItems.removeAll { (arrayToolStackItem) -> Bool in
			return arrayToolStackItem == toolStackItem
		}
		
		toolStackItem.stack = nil
	}
	
	func deselectAll() -> Void {
		toolStackItems.forEach { (toolStackItem) in
			toolStackItem.setSelected(false)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if stackView.axis == .horizontal {
			layer.cornerRadius = frame.size.height / 2
		} else {
			layer.cornerRadius = frame.size.width / 2
		}
	}
}
