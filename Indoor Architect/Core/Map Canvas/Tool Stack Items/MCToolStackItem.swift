//
//  MCToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol MCToolStackItemDelegate {
	func toolStackItem(_ toolStackItem: MCToolStackItem, registeredTapFrom tapGestureRecognizer: UITapGestureRecognizer) -> Void
}

class MCToolStackItem: UIView {
	
	/// The default background color for a selected tool stack item
	private static let selectedBackgroundColor = UIColor.white.withAlphaComponent(0.2)
	
	/// The default size for the tool stack item
	static let toolStackItemSize: CGFloat = 32
	
	/// Calculates the size for an image icon inside of the tool stack item to be completely visible
	private static var imageIconSize: CGFloat {
		get {
			return sqrt((MCToolStackItem.toolStackItemSize * MCToolStackItem.toolStackItemSize) / 2)
		}
	}
	
	/// The default tint color of the icons or the labels in the tool stack
	static let tintColor = UIColor.white.withAlphaComponent(0.6)
	
	/// The default prominent tint color of the icons or the labels in the tool stack
	static let prominentTintColor = UIColor.white.withAlphaComponent(0.8)
	
	/// A reference to the tool stack the item is part of
	var stack: MCToolStack?
	
	/// The image view which can be set with an icon to display
	let imageView = UIImageView()
	
	/// The title label which can be set with a text to display
	let titleLabel = UILabel()
	
	var tapGestureRecognizer: UITapGestureRecognizer?
	
	/// When set to true the tool stack item will not set the background indicating a selection
	var preventIndicatingSelection: Bool = false
	
	/// Whether the current tool stack item is selected
	var isSelected: Bool = false
	
	/// Whether the tool stack item is a default item in the tool stack
	var isDefault: Bool = false
	
	/// The delegate subclass tool stack item where the item logic is delegated to
	var delegate: MCToolStackItemDelegate?
	
	init(isDefault: Bool = false) {
		super.init(frame: .zero)
		autolayout()
		
		//
		// Sets the tool stack item properties
		self.isDefault	= isDefault
		
		//
		// Configures the UI elements for the different tool types
		configureImageView()
		configureTitleLabel()
		
		//
		// Adds the tap gesture recognizer for when the tool stack item is tapped
		tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
		if let recognizer = tapGestureRecognizer {
			addGestureRecognizer(recognizer)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Adds the icon image view to the tool stack item and configures its default settings
	private func configureImageView() -> Void {
		addSubview(imageView)
		imageView.autolayout()
		imageView.centerBoth()
		imageView.fixedSquaredBounds(MCToolStackItem.imageIconSize)
		
		imageView.contentMode					= .scaleAspectFit
		imageView.tintColor						= MCToolStackItem.tintColor
		imageView.preferredSymbolConfiguration	= UIImage.SymbolConfiguration(weight: .semibold)
	}
	
	/// Adds the title label to the tool stack item and configures its default settings
	private func configureTitleLabel() -> Void {
		addSubview(titleLabel)
		titleLabel.autolayout()
		titleLabel.centerVertically()
		titleLabel.horizontalEdgesToSuperview(withInsets: UIEdgeInsets(
			top:	0,
			left:	MCToolStackItem.toolStackItemSize / 2,
			bottom:	0,
			right:	MCToolStackItem.toolStackItemSize / 2
		), safeArea: false)
		
		titleLabel.textColor					= MCToolStackItem.tintColor
		titleLabel.adjustsFontSizeToFitWidth	= true
	}
		
	func setSelected(_ selected: Bool) -> Void {
		isSelected = selected
		if selected {
			backgroundColor = MCToolStackItem.selectedBackgroundColor
		} else {
			backgroundColor = .clear
		}
	}
	
	@objc func didTapItem(_ sender: UITapGestureRecognizer) -> Void {
		guard let recognizer = tapGestureRecognizer else {
			return
		}
		
		guard stack?.isPerformingAnimation == false else {
			return
		}

		let originRect = stack?.currentSelectedToolRect()
		stack?.deselectAll()

		if let originRect = originRect?.offsetBy(dx: 5, dy: 5) {

			let animationView = UIView(frame: originRect)
			stack?.addSubview(animationView)
			animationView.layer.cornerRadius	= originRect.height / 2
			animationView.backgroundColor		= MCToolStackItem.selectedBackgroundColor

			stack?.isPerformingAnimation = true
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
				animationView.frame = self.frame.offsetBy(dx: 5, dy: 5)
			}) { (success) in
				self.stack?.isPerformingAnimation = false
				animationView.removeFromSuperview()
				if !self.preventIndicatingSelection {
					self.setSelected(true)
				}

				self.delegate?.toolStackItem(self, registeredTapFrom: recognizer)
			}

		} else {
			if !preventIndicatingSelection {
				setSelected(true)
			}

			self.delegate?.toolStackItem(self, registeredTapFrom: recognizer)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = min(frame.size.height, frame.size.width) / 2
	}
}
