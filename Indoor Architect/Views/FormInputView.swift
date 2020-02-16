//
//  FormInputView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class FormInputView: UIView {

	private let textFieldInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
	
	private let textFieldWrapper = UIView()
	let infoLabel = UILabel()
	let textField = UITextField()
	
	init(title: String?, description: String?) {
		super.init(frame: CGRect.zero)
		translatesAutoresizingMaskIntoConstraints = false
		tintColor = Color.primary
		
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.text = description
		infoLabel.textColor = .secondaryLabel
		infoLabel.font = UIFont.preferredFont(forTextStyle: .callout)
		infoLabel.adjustsFontForContentSizeCategory = true
		addSubview(infoLabel)
		infoLabel.topAnchor.constraint(equalTo:					topAnchor).isActive = true
		infoLabel.trailingAnchor.constraint(lessThanOrEqualTo:	trailingAnchor).isActive = true
		infoLabel.leadingAnchor.constraint(equalTo:				leadingAnchor).isActive = true
		
		textFieldWrapper.translatesAutoresizingMaskIntoConstraints = false
		textFieldWrapper.backgroundColor = Color.tableViewCellSelection
		textFieldWrapper.layer.cornerRadius = 7.5
		addSubview(textFieldWrapper)
		textFieldWrapper.topAnchor.constraint(equalTo:		infoLabel.bottomAnchor, constant: 5).isActive = true
		textFieldWrapper.trailingAnchor.constraint(equalTo:	trailingAnchor).isActive = true
		textFieldWrapper.bottomAnchor.constraint(equalTo:	bottomAnchor).isActive = true
		textFieldWrapper.leadingAnchor.constraint(equalTo:	leadingAnchor).isActive = true
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.text = title
		textField.font = UIFont.preferredFont(forTextStyle: .body)
		textField.adjustsFontForContentSizeCategory = true
		textFieldWrapper.addSubview(textField)
		textField.topAnchor.constraint(equalTo:			textFieldWrapper.topAnchor,			constant: textFieldInsets.top).isActive = true
		textField.trailingAnchor.constraint(equalTo:	textFieldWrapper.trailingAnchor,	constant: -textFieldInsets.right).isActive = true
		textField.bottomAnchor.constraint(equalTo:		textFieldWrapper.bottomAnchor,		constant: -textFieldInsets.bottom).isActive = true
		textField.leadingAnchor.constraint(equalTo:		textFieldWrapper.leadingAnchor,		constant: textFieldInsets.left).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
