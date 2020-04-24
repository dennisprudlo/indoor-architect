//
//  ProjectExtensionEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExtensionEditController: ComposePopoverController {
	
	let providerCell		= TextInputTableViewCell(placeholder: "vision-software")
	let nameCell			= TextInputTableViewCell(placeholder: "parking-spots")
	let versionCell			= TextInputTableViewCell(placeholder: "2.3")
	
	var displayController: ProjectExtensionController?
	var shouldRenderToCreate: Bool = false
	var extensionToEdit: Extension?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		// Set the controller title
		title = shouldRenderToCreate ? Localizable.Extension.addExtension : Localizable.Extension.editExtension
		
		confirmButtonTitle = shouldRenderToCreate ? Localizable.General.add : Localizable.General.remove
		
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
		
		tableViewSections.append((
			title: Localizable.Extension.provider,
			description: Localizable.Extension.providerDescription,
			cells: [providerCell]
		))
		tableViewSections.append((
			title: Localizable.Extension.name,
			description: Localizable.Extension.nameDescription,
			cells: [nameCell]
		))
		tableViewSections.append((
			title: Localizable.Extension.version,
			description: Localizable.Extension.versionDescription,
			cells: [versionCell]
		))
		tableViewSections.append((
			title:			nil,
			description:	nil,
			cells:			[confirmButtonCell]
		))
		
		setExtensionButtonStates()
	}
	
	override func didTapSave(_ barButtonItem: UIBarButtonItem) -> Void {
		super.didTapSave(barButtonItem)
		
		guard let extensionToEdit = extensionToEdit else {
			return
		}
		
		let provider	= providerCell.textField.text ?? ""
		let name		= nameCell.textField.text ?? ""
		let version		= versionCell.textField.text ?? ""
		
		do {
			try displayController?.project?.addExtension(provider: provider, name: name, version: version)
			displayController?.project?.removeExtension(extensionToEdit)
			try displayController?.project?.save()
			
			displayController?.resetExtensions()
		} catch {
			print(error)
		}
	}
	
	override func didTapConfirm(_ sender: UIButton) -> Void {
		
		if !shouldRenderToCreate {
			if let extensionToRemove = extensionToEdit {
				displayController?.project?.removeExtension(extensionToRemove)
			}
			
			//
			// Try to save the project with the added extensions
			try? displayController?.project?.save()
			displayController?.resetExtensions()
			
			navigationController?.popViewController(animated: true)
		}
		
		if shouldRenderToCreate {
			guard let provider = providerCell.textField.text, let name = nameCell.textField.text, let version = versionCell.textField.text else {
				return
			}
			
			do {
				//
				// Add the new extension if valid and reset the table view
				try displayController?.project?.addExtension(provider: provider, name: name, version: version)
				
				//
				// Try to save the project with the added extensions
				try? displayController?.project?.save()
				displayController?.resetExtensions()
				
				dismiss(animated: true, completion: nil)
			} catch {
				print(error)
			}
		}
	}
	
	@objc func didChangeText(in textField: UITextField) -> Void {
		setExtensionButtonStates()
	}
	
	/// Sets the extension button states, whether they are enabled or disabled
	private func setExtensionButtonStates() -> Void {
		let provider	= providerCell.textField.text ?? ""
		let name		= nameCell.textField.text ?? ""
		let version		= versionCell.textField.text ?? ""
		
		if shouldRenderToCreate {
			do {
				let _ = try Extension.make(provider: provider, name: name, version: version)
				isConfirmButtonEnabled = true
			} catch {
				isConfirmButtonEnabled = false
			}
		}
		
		if !shouldRenderToCreate {
			guard let extensionToEdit = extensionToEdit else {
				hasChangesToSave = false
				return
			}

			do {
				let extensionToCompare = try Extension.make(provider: provider, name: name, version: version)

				//
				// If the both extensions (the one we want to edit and the one we created from our inputs)
				// are different, there are changes to commit
				hasChangesToSave = extensionToCompare.identifier != extensionToEdit.identifier
			} catch {
				hasChangesToSave = false
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableViewSections[indexPath.section].cells[indexPath.row]
		
		if !shouldRenderToCreate {
			cell.backgroundColor = Color.lightStyleCellBackground
		}
		
		return cell
	}
}
