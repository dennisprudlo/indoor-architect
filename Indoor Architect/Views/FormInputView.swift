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
	
	let textFieldWrapper = UIView()
	let infoLabel = UILabel()
	let textField = UITextField()
	
	var fieldDescription: String?
	var parentController: UIViewController?
	
	init(title: String?, label: String?, description: String? = nil) {
		super.init(frame: CGRect.zero)
		translatesAutoresizingMaskIntoConstraints = false
		tintColor = Color.primary
		
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.text = label
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
		
		//
		// When a label is set and a description string an info bubble can be shown
		// with a more detailed description of the input
		if let _ = label, let _ = description {
			self.fieldDescription = description
			
			let infoButton = UIButton(type: .infoDark)
			infoButton.translatesAutoresizingMaskIntoConstraints = false
			infoButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
			addSubview(infoButton)
			infoButton.topAnchor.constraint(equalTo: infoLabel.topAnchor).isActive = true
			infoButton.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor, constant: 5).isActive = true
			infoButton.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor).isActive = true
			infoButton.addTarget(self, action: #selector(didTapHelp), for: .touchUpInside)
		}
	}
	
	@objc func didTapHelp(_ sender: UIButton) -> Void {
		guard let fieldDescription = self.fieldDescription else {
			return
		}
		
		let popoverInfoViewController = PopoverInfoViewController()
		popoverInfoViewController.titleLabel.text = fieldDescription
		popoverInfoViewController.modalPresentationStyle = .popover
		popoverInfoViewController.popoverPresentationController?.sourceView = sender
		popoverInfoViewController.popoverPresentationController?.sourceRect = sender.bounds
	
		parentController?.present(popoverInfoViewController, animated: true, completion: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
