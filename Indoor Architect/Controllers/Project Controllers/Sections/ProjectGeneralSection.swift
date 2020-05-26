//
//  ProjectGeneralSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectGeneralSection: ProjectSection {
	
	let projectTitleCell		= TextInputTableViewCell(placeholder: Localizable.Project.projectTitle)
	let projectDescriptionCell	= TextInputTableViewCell(placeholder: Localizable.Project.projectDescription)
	let projectClientCell		= TextInputTableViewCell(placeholder: Localizable.Project.projectClient)
	
	override init() {
		super.init()
		
		cells.append(projectTitleCell)
		cells.append(projectDescriptionCell)
		cells.append(projectClientCell)
		
		projectTitleCell.textField.addTarget(self,			action: #selector(didChangeInput),	for: .editingChanged)
		projectDescriptionCell.textField.addTarget(self,	action: #selector(didChangeInput),	for: .editingChanged)
		projectClientCell.textField.addTarget(self,			action: #selector(didChangeInput),	for: .editingChanged)
	}
	
	/// Updates the project data after the project title was changed
	/// - Parameter sender: The text field that was edited
	@objc func didChangeInput(_ sender: UITextField) -> Void {
		delegate?.toggleSaveButton()
	
		if sender == projectTitleCell.textField {
			delegate?.title = projectTitleCell.textField.text
		}
	}
	
	func hasChangesToCurrentManifest() -> Bool {
		var hasChanges	= false
		let manifest	= Application.currentProject.manifest
	
		//
		// If the current title is different from the inputted title mark the change
		if manifest.title != projectTitleCell.textField.text ?? "" {
			hasChanges = true
		}
		
		//
		// If the current description has a value and is different from the inputted description mark the change
		if let description = manifest.description, description != projectDescriptionCell.textField.text ?? "" {
			hasChanges = true
		}
		
		//
		// If the current description has no value but the inputted description is at least 1 character long mark the change
		if manifest.description == nil && (projectDescriptionCell.textField.text?.count ?? 0) > 0 {
			hasChanges = true
		}
		
		//
		// If the current client has a value and is different from the inputted client mark the change
		if let client = manifest.client, client != projectClientCell.textField.text ?? "" {
			hasChanges = true
		}
		
		//
		// If the current client has no value but the inputted client is at least 1 character long mark the change
		if manifest.client == nil && (projectClientCell.textField.text?.count ?? 0) > 0 {
			hasChanges = true
		}
		
		return hasChanges
	}
	
	func getProcessedInputs() -> (title: String, description: String?, client: String?) {
		return (
			title:			projectTitleCell.textField.text ?? "",
			description:	(projectDescriptionCell.textField.text?.count ?? 0) > 0 ? projectDescriptionCell.textField.text : nil,
			client:			(projectClientCell.textField.text?.count ?? 0) > 0 ? projectClientCell.textField.text : nil
		)
	}
	
	override func initialize() {
		projectTitleCell.setText(Application.currentProject.manifest.title)
		projectDescriptionCell.setText(Application.currentProject.manifest.description)
		projectClientCell.setText(Application.currentProject.manifest.client)
	}
}
