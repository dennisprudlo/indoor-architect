//
//  TextInputTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class TextInputTableViewCell: UITableViewCell, UITextFieldDelegate {

	let textField = UITextField()
	let lengthLabel = UILabel()
	let maxLength: Int?
	
	init(placeholder: String, maxLength length: Int? = nil) {
		self.maxLength = length
		super.init(style: .default, reuseIdentifier: nil)
		
		selectionStyle	= .none		
		tintColor		= Color.primary
		
		contentView.addSubview(textField)
		textField.autolayout()
		textField.placeholder						= placeholder
		textField.font								= UIFont.preferredFont(forTextStyle: .body)
		textField.adjustsFontForContentSizeCategory	= true
		textField.delegate							= self
		textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
		
		contentView.addSubview(lengthLabel)
		lengthLabel.autolayout()
		lengthLabel.font								= UIFont.preferredFont(forTextStyle: .body)
		lengthLabel.textColor							= .placeholderText
		lengthLabel.adjustsFontForContentSizeCategory	= true
		
		textField.centerVertically()
		lengthLabel.centerVertically()
		
		let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 20)
		if let _ = length {
			updateLengthLabelText()
			NSLayoutConstraint.activate([
				textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edgeInsets.left),
				lengthLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: edgeInsets.left),
				lengthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeInsets.right)
			])
		} else {
			textField.horizontalEdgesToSuperview(withInsets: edgeInsets, safeArea: false)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateLengthLabelText() -> Void {
		guard let maxLength = self.maxLength, let count = textField.text?.count else {
			return
		}
		
		lengthLabel.text = "\(count)/\(maxLength)"
	}
	
	func setText(_ text: String?) {
		textField.text = text
		updateLengthLabelText()
	}
	
	@objc func didChangeText(_ sender: UITextField) -> Void {
		updateLengthLabelText()
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
