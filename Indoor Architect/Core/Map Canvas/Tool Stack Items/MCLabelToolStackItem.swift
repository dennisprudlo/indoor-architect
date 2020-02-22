//
//  MCLabelToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCLabelToolStackItem: MCToolStackItem, MCToolStackItemDelegate {
	
	override init(isDefault: Bool = false) {
		super.init(isDefault: isDefault)
		super.delegate = self
		
		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalToConstant: MCToolStackItem.toolStackItemSize)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setTitle(_ title: String?) -> Void {
		titleLabel.text = title
	}
	
	func setAttributedTitle(_ attributedTitle: NSMutableAttributedString?) -> Void {
		titleLabel.attributedText = attributedTitle
	}
	
	func setLabelTitle(label: String, title: String) -> Void {
		let attributedString = NSMutableAttributedString(string: "\(label): \(title)", attributes: [
			NSAttributedString.Key.font:			titleLabel.font!,
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.tintColor
		])
		
		//
		// Add bold attribute for the label
		attributedString.addAttributes([
			NSAttributedString.Key.font:			titleLabel.font.bold(),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.prominentTintColor
		], range: NSRange(location: 0, length: label.count))
		
		titleLabel.attributedText = attributedString
	}
	
	func toolStackItem(_ toolStackItem: MCToolStackItem, registeredTapFrom tapGestureRecognizer: UITapGestureRecognizer) {
		
	}
}
