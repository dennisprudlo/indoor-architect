//
//  MCToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCToolStackItem: UIView {
	
	private let selectedBackgroundColor = UIColor.white.withAlphaComponent(0.2)
	
	private let toolIconSize: CGFloat = 32
	private var imageIconSize: CGFloat {
		get {
			return sqrt((toolIconSize * toolIconSize) / 2)
		}
	}
	
	static let tintColor = UIColor.white.withAlphaComponent(0.6)
	static let prominentTintColor = UIColor.white.withAlphaComponent(0.8)
	
	private var toolType: MCToolStackItem.ToolType = .custom
	var stack: MCToolStack?
	
	private let imageView = UIImageView()
	let titleLabel = UILabel()
	
	var actionLeavesContext: Bool = false
	
	var isSelected: Bool = false
	var isDefault: Bool = false
	
	enum ToolType {
		case custom
		case label
		case close
		case drawingTool(type: MCMapCanvas.DrawingTool)
	}
	
	init(type: MCToolStackItem.ToolType, isDefault: Bool = false) {
		super.init(frame: .zero)
		autolayout()
		
		self.toolType = type
		self.isDefault = isDefault
		
		addSubview(imageView)
		imageView.contentMode					= .scaleAspectFit
		imageView.tintColor						= MCToolStackItem.tintColor
		imageView.preferredSymbolConfiguration	= UIImage.SymbolConfiguration(weight: .semibold)
		imageView.autolayout()
		imageView.centerBoth()
		imageView.fixedSquaredBounds(imageIconSize)
		
		addSubview(titleLabel)
		titleLabel.textColor = MCToolStackItem.tintColor
		titleLabel.autolayout()
		titleLabel.centerVertically()
		titleLabel.horizontalEdgesToSuperview(withInsets: UIEdgeInsets(top: 0, left: toolIconSize / 2, bottom: 0, right: toolIconSize / 2), safeArea: false)
		titleLabel.adjustsFontSizeToFitWidth = true
		
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
			case .label:
				imageView.image = nil
			case .close:
				imageView.image = Icon.toolClose
				actionLeavesContext = true
			case .drawingTool(let type):
				imageView.image = Icon.imageFor(drawingTool: type)
		}
		
		switch toolType {
			case .label:
				NSLayoutConstraint.activate([
					heightAnchor.constraint(equalToConstant: toolIconSize)
				])
			default:
				NSLayoutConstraint.activate([
					widthAnchor.constraint(equalToConstant: toolIconSize),
					heightAnchor.constraint(equalTo: widthAnchor)
				])
		}
	}
	
	func setSelected(_ selected: Bool) -> Void {
		isSelected = selected
		if selected {
			backgroundColor = selectedBackgroundColor
		} else {
			backgroundColor = .clear
		}
	}
	
	@objc func didTapItem(_ sender: UIView) -> Void {
		guard stack?.isPerformingAnimation == false else {
			return
		}
		
		let originRect = stack?.currentSelectedToolRect()
		stack?.deselectAll()
		
		if let originRect = originRect?.offsetBy(dx: 5, dy: 5) {
			
			let animationView = UIView(frame: originRect)
			stack?.addSubview(animationView)
			animationView.layer.cornerRadius	= originRect.height / 2
			animationView.backgroundColor		= selectedBackgroundColor
			
			stack?.isPerformingAnimation = true
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
				animationView.frame = self.frame.offsetBy(dx: 5, dy: 5)
			}) { (success) in
				self.stack?.isPerformingAnimation = false
				animationView.removeFromSuperview()
				if !self.actionLeavesContext {
					self.setSelected(true)
				}
				
				self.executeHandler()
			}
			
		} else {
			if !actionLeavesContext {
				setSelected(true)
			}
			
			executeHandler()
		}
	}
	
	private func executeHandler() -> Void {
		switch toolType {
			case .custom:
				print("custom handler")
			case .close:
				MapCanvasViewController.shared.dismiss(animated: true, completion: nil)
			case .drawingTool(let type):
				MapCanvasViewController.shared.canvas.switchDrawingTool(type)
			case .label:
				print("label tap")
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = min(frame.size.height, frame.size.width) / 2
	}
}
