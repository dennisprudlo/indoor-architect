//
//  ProjectExtensionController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExtensionController: DetailTableViewController {
	
	var project: IMDFProject?
	
	private var groupedExtensions: [(key: String, value: [Extension])] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.ProjectExplorer.Project.extensions
		
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
	
	func resetExtensions() -> Void {
		guard let extensions = project?.imdfArchive.manifest.extensions else {
			groupedExtensions = []
			tableView.reloadData()
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
		
		let name		= groupedExtensions[indexPath.section].value[indexPath.row].name
		let version		= groupedExtensions[indexPath.section].value[indexPath.row].version
		let identifier	= groupedExtensions[indexPath.section].value[indexPath.row].identifier
		
		cell.textLabel?.text		= name
		cell.detailTextLabel?.text	= "\(version) – \(identifier)"
		cell.backgroundColor		= Color.lightStyleCellBackground
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
}
