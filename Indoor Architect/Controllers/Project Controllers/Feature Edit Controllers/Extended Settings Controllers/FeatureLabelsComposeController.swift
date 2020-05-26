//
//  FeatureLabelsComposeController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol FeatureLabelsComposeControllerDelegate {
	func labelComposeController(_ controller: FeatureLabelsComposeController, didEditLabelWith key: String, newIdentifier: String, and label: String) -> Void
	func labelComposeController(_ controller: FeatureLabelsComposeController, didTapRemoveLabelWith key: String) -> Void
}

class FeatureLabelsComposeController: IATableViewController {

	/// The cell where the user shall put the language identifier
	let languageIdentifierCell	= TextInputTableViewCell(placeholder: "en, en-US or en-Latn-US, ...", maxLength: 10)
	
	/// The cell where the user shall put the label
	let labelCell				= TextInputTableViewCell(placeholder: "Hallewood Mall")
	
	/// Defines which key in the label set is being edited. If the key does not exist in the label set it will get pasted.
	/// If it exists the language identifier as well as the label itself are being overwritten
	var editWithKey				= ""
	
	/// The delegate that handles the label edit
	var delegate: FeatureLabelsComposeControllerDelegate?
	
	/// When this is set to true the dismissal of the controller wont trigger the delegate
	private var dismissWithoutDelegating: Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//
		// Add the right bar button to remove the label from the set
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapRemoveLabel(_:)))
		
		let defaultFont = languageIdentifierCell.textField.font
		
		languageIdentifierCell.textField.font					= languageIdentifierCell.textField.font?.monospaced()
		languageIdentifierCell.textField.autocorrectionType		= .no
		languageIdentifierCell.textField.autocapitalizationType	= .none
		
		//
		// Use the default font for the placeholder
		if let font = defaultFont {
			let attributes = [ NSAttributedString.Key.font: font ]
			languageIdentifierCell.textField.attributedPlaceholder = NSAttributedString(string: "en, en-US or en-Latn-US, ...", attributes: attributes)
		}
		
		//
		// Append the cells
		tableViewSections.append((
			title:			Localizable.Feature.labelLanguage,
			description:	Localizable.Feature.labelLanguageDescription,
			cells:			[languageIdentifierCell]
		))
		tableViewSections.append((
			title:			Localizable.Feature.label,
			description:	Localizable.Feature.labelDescription,
			cells:			[labelCell]
		))
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//
		// If the view controller is being dismissed (closed) we want to collect
		// the new label data and update the label set
		if isMovingFromParent && !dismissWithoutDelegating {
			delegate?.labelComposeController(self, didEditLabelWith: editWithKey, newIdentifier: languageIdentifierCell.textField.text ?? "", and: labelCell.textField.text ?? "")
		}
	}
	
	@objc func didTapRemoveLabel(_ barButtonItem: UIBarButtonItem) -> Void {
		dismissWithoutDelegating = true
		delegate?.labelComposeController(self, didTapRemoveLabelWith: editWithKey)
	}
}
