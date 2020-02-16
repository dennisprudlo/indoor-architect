//
//  TextInputTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class TextInputTableViewCell: UITableViewCell, UITextFieldDelegate {

	private let viewInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
	
	let textField = UITextField()
	let lengthLabel = UILabel()
	let maxLength: Int?
	
	init(placeholder: String, maxLength length: Int? = nil) {
		self.maxLength = length
		super.init(style: .default, reuseIdentifier: nil)
		
		selectionStyle = .none
		tintColor = Color.primary
		
		contentView.addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = placeholder
		textField.font = UIFont.preferredFont(forTextStyle: .body)
		textField.adjustsFontForContentSizeCategory = true
		textField.delegate = self
		
		textField.topAnchor.constraint(equalTo:			topAnchor,		constant: viewInset.top).isActive = true
		textField.trailingAnchor.constraint(equalTo:	trailingAnchor,	constant: -viewInset.right).isActive = true
		textField.bottomAnchor.constraint(equalTo:		bottomAnchor,	constant: -viewInset.bottom).isActive = true
		textField.leadingAnchor.constraint(equalTo:		leadingAnchor,	constant: viewInset.left).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let maxLength = self.maxLength else {
			return true
		}
		
		guard let text = textField.text, let range = Range(range, in: text) else {
			return false
		}
		
		let substring = text[range]
		let count = text.count - substring.count + string.count
		return count <= maxLength
	}
}
