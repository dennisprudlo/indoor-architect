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
		
		addSubview(infoLabel)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.text = label
		infoLabel.textColor = .secondaryLabel
		infoLabel.font = UIFont.preferredFont(forTextStyle: .callout)
		infoLabel.adjustsFontForContentSizeCategory = true
		infoLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
		NSLayoutConstraint.activate([
			infoLabel.topAnchor.constraint(equalTo:					topAnchor),
			infoLabel.trailingAnchor.constraint(lessThanOrEqualTo:	trailingAnchor),
			infoLabel.leadingAnchor.constraint(equalTo:				leadingAnchor)
		])
		
		addSubview(textFieldWrapper)
		textFieldWrapper.translatesAutoresizingMaskIntoConstraints = false
		textFieldWrapper.backgroundColor = Color.tableViewCellSelection
		textFieldWrapper.layer.cornerRadius = Style.cornerRadius
		NSLayoutConstraint.activate([
			textFieldWrapper.topAnchor.constraint(equalTo:		infoLabel.bottomAnchor, constant: 5),
			textFieldWrapper.trailingAnchor.constraint(equalTo:	trailingAnchor),
			textFieldWrapper.bottomAnchor.constraint(equalTo:	bottomAnchor),
			textFieldWrapper.leadingAnchor.constraint(equalTo:	leadingAnchor)
		])
		
		textFieldWrapper.addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.text = title
		textField.font = UIFont.preferredFont(forTextStyle: .body)
		textField.adjustsFontForContentSizeCategory = true
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo:			textFieldWrapper.topAnchor,			constant: textFieldInsets.top),
			textField.trailingAnchor.constraint(equalTo:	textFieldWrapper.trailingAnchor,	constant: -textFieldInsets.right),
			textField.bottomAnchor.constraint(equalTo:		textFieldWrapper.bottomAnchor,		constant: -textFieldInsets.bottom),
			textField.leadingAnchor.constraint(equalTo:		textFieldWrapper.leadingAnchor,		constant: textFieldInsets.left)
		])
		
		//
		// When a label is set and a description string an info bubble can be shown
		// with a more detailed description of the input
		if let _ = label, let _ = description {
			self.fieldDescription = description
			
			let infoButton = UIButton(type: .system)
			addSubview(infoButton)
			infoButton.setImage(Icon.help, for: .normal)
			infoButton.imageView?.contentMode = .scaleAspectFit
			infoButton.translatesAutoresizingMaskIntoConstraints = false
			infoButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
			NSLayoutConstraint.activate([
				infoButton.topAnchor.constraint(equalTo: infoLabel.topAnchor),
				infoButton.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
				infoButton.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor)
			])
			
			infoButton.addTarget(self, action: #selector(didTapHelp), for: .touchUpInside)
		}
	}
	
	/// Present a popover view with a description of the current input field
	/// - Parameter sender: The info button that was tapped
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
