//
//  MCToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCToolStackItem: UIView {
	
	private let toolIconSize: CGFloat = 32
	private var toolType: MCToolStackItem.ToolType = .custom
	var stack: MCToolStack?
	
	private let imageView = UIImageView()
	
	var actionLeavesContext: Bool = false
	
	enum ToolType {
		case custom
		case close
		case drawingTool(type: MCMapCanvas.DrawingTool)
	}
	
	init(type: MCToolStackItem.ToolType) {
		super.init(frame: .zero)
		autolayout()
		
		toolType = type
		
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: toolIconSize),
			heightAnchor.constraint(equalTo: widthAnchor)
		])
		
		addSubview(imageView)
		imageView.tintColor = UIColor.systemGray6.withAlphaComponent(0.7)
		imageView.autolayout()
		imageView.edgesToSuperview()
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapItem)))
		
		prepare()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func prepare() -> Void {
		switch toolType {
			case .custom:
				imageView.image = nil
			case .close:
				imageView.image = Icon.toolClose
				actionLeavesContext = true
			case .drawingTool(let type):
				imageView.image = Icon.help
		}
	}
	
	func setSelected(_ selected: Bool) -> Void {
		if selected {
			backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
		} else {
			backgroundColor = .clear
		}
	}
	
	@objc func didTapItem(_ sender: UIView) -> Void {
		stack?.deselectAll()
		
		if !actionLeavesContext {
			setSelected(true)
		}
		
		executeHandler()
	}
	
	private func executeHandler() -> Void {
		switch toolType {
			case .custom:
				print("custom handler")
			case .close:
				MapCanvasViewController.shared.dismiss(animated: true, completion: nil)
			case .drawingTool(let type):
				MapCanvasViewController.shared.canvas.switchDrawingTool(type)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = frame.size.width / 2
	}
}
