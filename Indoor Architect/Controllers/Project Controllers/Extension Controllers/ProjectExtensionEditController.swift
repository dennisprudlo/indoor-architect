//
//  ProjectExtensionEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExtensionEditController: ComposePopoverController {
	
	let providerCell		= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Extension.provider)
	let nameCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Extension.name)
	let versionCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Extension.version)
	
	var displayController: ProjectExtensionController?
	var shouldRenderToCreate: Bool = false
	var extensionToEdit: Extension?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		// Set the controller title
		title = shouldRenderToCreate ? Localizable.ProjectExplorer.Project.Extension.addExtension : Localizable.ProjectExplorer.Project.Extension.editExtension
		
		confirmButtonTitle = shouldRenderToCreate ? Localizable.ProjectExplorer.Project.Extension.add : Localizable.ProjectExplorer.Project.Extension.remove
		
		//
		// Add the cancel bar button item
		navigationItem.leftBarButtonItem	= UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
		
		//
		// Configure the table view itself
		tableView.rowHeight = UITableView.automaticDimension
		
		//
		// Configure the table view sections
		if !shouldRenderToCreate {
			tableView.cellLayoutMarginsFollowReadableWidth	= true
			tableView.backgroundColor						= Color.lightStyleTableViewBackground
			tableView.separatorColor						= Color.lightStyleCellSeparatorColor
			
			navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
			
			providerCell.textField.text	= extensionToEdit?.provider
			nameCell.textField.text		= extensionToEdit?.name
			versionCell.textField.text	= extensionToEdit?.version
		}
		
		//
		// Disable autocorrection and autocapitalization
		providerCell.textField.autocapitalizationType	= .none
		providerCell.textField.autocorrectionType		= .no
		nameCell.textField.autocapitalizationType		= .none
		nameCell.textField.autocorrectionType			= .no
		versionCell.textField.autocapitalizationType	= .none
		versionCell.textField.autocorrectionType		= .no
		
		//
		// Configure cell event handler
		providerCell.textField.addTarget(self, action: #selector(didChangeText(in:)), for: .editingChanged)
		nameCell.textField.addTarget(self, action: #selector(didChangeText(in:)), for: .editingChanged)
		versionCell.textField.addTarget(self, action: #selector(didChangeText(in:)), for: .editingChanged)
		
		//
		// Set the provider cell to become the first responder
		providerCell.textField.becomeFirstResponder()
		
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: [providerCell, nameCell, versionCell]
		))
		tableViewSections.append((
			title:			nil,
			description:	nil,
			cells:			[confirmButtonCell]
		))
		
		checkAddExtensionButtonState()
	}
	
	override func didTapCreate(_ sender: UIButton) -> Void {
		guard let provider = providerCell.textField.text, let name = nameCell.textField.text, let version = versionCell.textField.text else {
			return
		}
		
		do {
			//
			// Add the new extension if valid and reset the table view
			try displayController?.project?.addExtension(provider: provider, name: name, version: version)
			displayController?.resetExtensions()
			
			//
			// Try to save the project with the added extensions
			try displayController?.project?.save()
			
			dismiss(animated: true, completion: nil)
		} catch {
			print(error)
		}
	}
	
	@objc func didChangeText(in textField: UITextField) -> Void {
		checkAddExtensionButtonState()
	}
	
	private func checkAddExtensionButtonState() -> Void {
//		guard let provider = providerCell.textField.text, let name = nameCell.textField.text, let version = versionCell.textField.text else {
//			addExtensionCell.setEnabled(false)
//			return
//		}
//		
//		if provider.count == 0 || name.count == 0 || version.count == 0 {
//			addExtensionCell.setEnabled(false)
//			return
//		}
//		
//		addExtensionCell.setEnabled(true)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableViewSections[indexPath.section].cells[indexPath.row]
		
		if !shouldRenderToCreate {
			cell.backgroundColor = Color.lightStyleCellBackground
		}
		
		return cell
	}
}
