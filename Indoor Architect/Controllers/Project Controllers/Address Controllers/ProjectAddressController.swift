//
//  ProjectAddressController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectAddressController: DetailTableViewController {
		
	var project: IMDFProject! {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.ProjectExplorer.Project.addresses
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapAddAddress))
	}
	
	@objc private func didTapAddAddress(_ sender: UIBarButtonItem) -> Void {
		let createController = ProjectAddressEditController(style: .insetGrouped)
		createController.displayController = self
		createController.shouldRenderToCreate = true

		let navigationController = UINavigationController(rootViewController: createController)
		navigationController.modalPresentationStyle = .popover
		navigationController.popoverPresentationController?.barButtonItem = sender

		present(navigationController, animated: true, completion: nil)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return project.imdfArchive.addresses.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.accessoryType = .disclosureIndicator
		
		let address		= project.imdfArchive.addresses[indexPath.row]
		
		var addressString = address.properties.address
		if let unit = address.properties.unit {
			addressString = "\(addressString), \(unit)"
		}
		
		var localityString	= address.properties.locality
		localityString		= "\(localityString), \(address.getSubdivisionData()?.title ?? address.properties.province)"
		localityString		= "\(localityString), \(address.getCountryData()?.title ?? address.properties.country)"
		
		cell.textLabel?.text		= addressString
		cell.detailTextLabel?.text	= localityString
		cell.backgroundColor		= Color.lightStyleCellBackground
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let editController = ProjectAddressEditController(style: .insetGrouped)
		editController.displayController = self
		editController.addressToEdit = project.imdfArchive.addresses[indexPath.row]
		
		navigationController?.pushViewController(editController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completion) in
			let archive			= self.project.imdfArchive
			let addressToDelete = archive.addresses[indexPath.row]
			
			archive.delete(addressToDelete)
			
			guard let _ = try? archive.save(.address) else {
				completion(false)
				return
			}
			
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .left)
			tableView.endUpdates()
			
			completion(true)
		})
		deleteAction.backgroundColor = Color.primary
		deleteAction.image = Icon.trash
		
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
}
