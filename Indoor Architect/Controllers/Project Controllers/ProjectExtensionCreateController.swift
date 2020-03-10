//
//  ProjectExtensionCreateController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExtensionCreateController: UITableViewController {
	
	let providerCell		= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.extensionProvider)
	let nameCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.extensionName)
	let versionCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.extensionVersion)
	let addExtensionCell	= ButtonTableViewCell(title: Localizable.ProjectExplorer.Project.addExtensionTitle)
	
	var displayController: ProjectExtensionsController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		// Set the controller title
		title = Localizable.ProjectExplorer.Project.addExtensionTitle
		
		
		//
		// Add the cancel bar button item
		navigationItem.leftBarButtonItem	= UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
		
		//
		// Configure the table view itself
		tableView.rowHeight = UITableView.automaticDimension
		tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
		
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
		// Configure create button
		addExtensionCell.cellButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
		
		//
		// Set the provider cell to become the first responder
		providerCell.textField.becomeFirstResponder()
		
		checkAddExtensionButtonState()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		tableView.removeObserver(self, forKeyPath: "contentSize")
	}
	
	/// Dismiss the add extension modal when tapping cancel
	/// - Parameter sender: The bar button item that was tapped
	@objc func didTapCancel(_ sender: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func didTapCreate(_ sender: UIButton) -> Void {
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
		guard let provider = providerCell.textField.text, let name = nameCell.textField.text, let version = versionCell.textField.text else {
			addExtensionCell.setEnabled(false)
			return
		}
		
		if provider.count == 0 || name.count == 0 || version.count == 0 {
			addExtensionCell.setEnabled(false)
			return
		}
		
		addExtensionCell.setEnabled(true)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		self.preferredContentSize = tableView.contentSize
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 3 : 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			return [providerCell, nameCell, versionCell][indexPath.row]
		} else {
			return addExtensionCell
		}
	}
	
}
