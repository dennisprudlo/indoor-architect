//
//  ProjectAddressController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol ProjectAddressControllerDelegate {
	func addressPicker(_ picker: ProjectAddressController, didPickAddress address: Address?) -> Void
}

class ProjectAddressController: DetailTableViewController {
	
	var address: Address?
	
	var delegate: ProjectAddressControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.Address.title
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if delegate != nil && address != nil {
			
			//
			// If the delegate is set and a currently selected address we want to show a remove button
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizable.General.remove, style: .plain, target: self, action: #selector(didTapRemoveSelection(_:)))
		} else if delegate == nil {
			
			//
			// If the delegate is not set we show the compose button (we are not in edit mode)
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapAddAddress))
		}
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
	
	@objc private func didTapRemoveSelection(_ sender: UIBarButtonItem) -> Void {
		delegate?.addressPicker(self, didPickAddress: nil)
		navigationController?.popViewController(animated: true)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Application.currentProject.imdfArchive.addresses.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
			
		let address	= Application.currentProject.imdfArchive.addresses[indexPath.row]
		
		if delegate == nil {
			cell.accessoryType = .disclosureIndicator
		} else {
			cell.accessoryType = .none
			if let currentAddress = self.address, currentAddress.id.uuidString == address.id.uuidString {
				cell.accessoryType = .checkmark
			}
		}
		
		var addressString = address.properties.address
		if let unit = address.properties.unit {
			addressString = "\(addressString), \(unit)"
		}
		
		cell.textLabel?.text		= addressString
		cell.detailTextLabel?.text	= address.getInlineLocality()
		cell.tintColor				= Color.primary
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let address = Application.currentProject.imdfArchive.addresses[indexPath.row]
		
		if delegate != nil {
			delegate?.addressPicker(self, didPickAddress: address)
			navigationController?.popViewController(animated: true)
			return
		}
		
		let editController = ProjectAddressEditController(style: .insetGrouped)
		editController.displayController = self
		editController.addressToEdit = Application.currentProject.imdfArchive.addresses[indexPath.row]
		
		navigationController?.pushViewController(editController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		if delegate != nil {
			return nil
		}
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, completion) in
			let controller = UIAlertController(title: Localizable.General.actionConfirmation, message: Localizable.Address.removeAddressInfo, preferredStyle: .alert)
			controller.addAction(UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: { _ in completion(false) }))
			controller.addAction(UIAlertAction(title: Localizable.General.remove, style: .destructive, handler: { _ in
				let archive			= Application.currentProject.imdfArchive
				let addressToDelete = archive.addresses[indexPath.row]
				
				archive.removeFeature(with: addressToDelete.id)
				
				guard let _ = try? archive.save(.address) else {
					completion(false)
					return
				}
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .left)
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
