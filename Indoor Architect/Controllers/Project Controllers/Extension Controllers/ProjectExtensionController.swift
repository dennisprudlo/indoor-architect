//
//  ProjectExtensionController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExtensionController: DetailTableViewController {
	
	private var groupedExtensions: [(key: String, value: [Extension])] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.Extension.title
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapAddExtension))
		
		resetExtensions()
	}
	
	@objc private func didTapAddExtension(_ sender: UIBarButtonItem) -> Void {
		let projectExtensionCreateController = ProjectExtensionEditController(style: .insetGrouped)
		projectExtensionCreateController.displayController = self
		projectExtensionCreateController.shouldRenderToCreate = true
		
		let createProjectViewController = UINavigationController(rootViewController: projectExtensionCreateController)
		createProjectViewController.modalPresentationStyle = .popover
		createProjectViewController.popoverPresentationController?.barButtonItem = sender
		
		present(createProjectViewController, animated: true, completion: nil)
	}
	
	func resetExtensions(reloadTableView: Bool = true) -> Void {
		guard let extensions = Application.currentProject.imdfArchive.manifest.extensions else {
			groupedExtensions = []
			if reloadTableView {
				tableView.reloadData()
			}
			return
		}
		
		let grouped = Dictionary(grouping: extensions, by: { $0.provider.lowercased() })
		groupedExtensions = grouped.sorted { (firstKey, secondKey) -> Bool in
			return firstKey.key.lowercased() < secondKey.key.lowercased()
		}
		
		if reloadTableView {
			tableView.reloadData()
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return groupedExtensions.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return groupedExtensions[section].key
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groupedExtensions[section].value.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		
		let name		= groupedExtensions[indexPath.section].value[indexPath.row].name
		let version		= groupedExtensions[indexPath.section].value[indexPath.row].version
		let identifier	= groupedExtensions[indexPath.section].value[indexPath.row].identifier
		
		cell.textLabel?.text		= name
		cell.detailTextLabel?.text	= "\(version) – \(identifier)"
		cell.accessoryType			= .disclosureIndicator
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let editController					= ProjectExtensionEditController(style: .insetGrouped)
		editController.displayController	= self
		editController.shouldRenderToCreate	= false
		editController.extensionToEdit		= groupedExtensions[indexPath.section].value[indexPath.row]
		
		navigationController?.pushViewController(editController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completion) in
			let controller = UIAlertController(title: Localizable.General.actionConfirmation, message: Localizable.Extension.removeExtensionInfo, preferredStyle: .alert)
			controller.addAction(UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: { _ in completion(false) }))
			controller.addAction(UIAlertAction(title: Localizable.General.remove, style: .destructive, handler: { _ in
				let section				= self.groupedExtensions[indexPath.section].value
				let extensionToRemove	= section[indexPath.row]
				Application.currentProject.removeExtension(extensionToRemove)
				
				guard let _ = try? Application.currentProject.save() else {
					completion(false)
					return
				}
				
				self.resetExtensions(reloadTableView: false)
				
				tableView.beginUpdates()
				if section.count == 1 {
					tableView.deleteSections(IndexSet([indexPath.section]), with: .left)
				} else {
					tableView.deleteRows(at: [indexPath], with: .left)
				}
				tableView.endUpdates()
				
				completion(true)
			}))
			
			self.present(controller, animated: true, completion: nil)
		})
		deleteAction.backgroundColor = Color.primary
		deleteAction.image = Icon.trash
		
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
}
