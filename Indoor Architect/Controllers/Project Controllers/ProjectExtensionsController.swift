//
//  ProjectExtensionsController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExtensionsController: DetailTableViewController {
	
	var project: IMDFProject? {
		didSet {
			resetExtensions()
		}
	}
	
	private var groupedExtensions: [(key: String, value: [Extension])] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.ProjectExplorer.Project.extensions
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddExtension))
	}
	
	@objc private func didTapAddExtension(_ sender: UIBarButtonItem) -> Void {
		let projectExtensionCreateController = ProjectExtensionCreateController(style: .insetGrouped)
		projectExtensionCreateController.displayController = self
		
		let createProjectViewController = UINavigationController(rootViewController: projectExtensionCreateController)
		createProjectViewController.modalPresentationStyle = .popover
		createProjectViewController.popoverPresentationController?.barButtonItem = sender
		
		present(createProjectViewController, animated: true, completion: nil)
	}
	
	func resetExtensions() -> Void {
		guard let extensions = project?.imdfArchive.manifest.extensions else {
			return
		}
		
		let grouped = Dictionary(grouping: extensions, by: { $0.provider.lowercased() })
		groupedExtensions = grouped.sorted { (firstKey, secondKey) -> Bool in
			return firstKey.key.lowercased() > secondKey.key.lowercased()
		}
		
		tableView.reloadData()
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
		cell.selectionStyle = .none
		
		let name		= groupedExtensions[indexPath.section].value[indexPath.row].name
		let version		= groupedExtensions[indexPath.section].value[indexPath.row].version
		let identifier	= groupedExtensions[indexPath.section].value[indexPath.row].identifier
		
		cell.textLabel?.text = name
		cell.detailTextLabel?.text = "\(version) – \(identifier)"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completion) in
			if self.groupedExtensions.count <= indexPath.section {
				completion(false)
				return
			}
			
			let extensionGroup = self.groupedExtensions[indexPath.section]
			if extensionGroup.value.count <= indexPath.row {
				completion(false)
				return
			}
			
			let extensionToRemove = extensionGroup.value[indexPath.row]
			self.project?.removeExtension(extensionToRemove)
			
			guard let _ = try? self.project?.save() else {
				completion(false)
				return
			}
			
			self.resetExtensions()
			
			completion(true)
		})
		deleteAction.backgroundColor	= Color.primary
		deleteAction.image				= Icon.trash
			
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
}
