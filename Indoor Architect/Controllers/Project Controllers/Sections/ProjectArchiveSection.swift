//
//  ProjectArchiveSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectArchiveSection: ProjectSection {
	
	var archive: IMDFArchive?
	
	let customExtensionsCell	= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let addressesCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	override init() {
		super.init()
		
		customExtensionsCell.backgroundColor	= Color.lightStyleCellBackground
		customExtensionsCell.accessoryType		= .disclosureIndicator
		
		addressesCell.backgroundColor			= Color.lightStyleCellBackground
		addressesCell.accessoryType				= .disclosureIndicator
		
		cells.append(customExtensionsCell)
		cells.append(addressesCell)
		
		customExtensionsCell.textLabel?.text = Localizable.ProjectExplorer.Project.extensions
		addressesCell.textLabel?.text = Localizable.ProjectExplorer.Project.addresses
	}
	
	func resetExtensionCount() -> Void {
		guard let extensionCount = archive?.manifest.extensions.count else {
			customExtensionsCell.detailTextLabel?.text = "None"
			return
		}
		
		if extensionCount == 1 {
			customExtensionsCell.detailTextLabel?.text = archive?.manifest.extensions.first?.identifier
		} else {
			customExtensionsCell.detailTextLabel?.text = "\(extensionCount)"
		}
	}
	
	func resetAddressesCount() -> Void {
		guard let addressesCount = archive?.addresses.count else {
			addressesCell.detailTextLabel?.text = "None"
			return
		}
		
		addressesCell.detailTextLabel?.text = "\(addressesCount)"
	}
	
	override func titleForHeader() -> String? {
		return Localizable.ProjectExplorer.Project.archiveSectionTitle
	}
	
	override func didSelectRow(at index: Int) {
		if cells[index] == customExtensionsCell {
			let projectExtensionsController = ProjectExtensionController(style: .insetGrouped)
			projectExtensionsController.project = delegate?.project
			delegate?.navigationController?.pushViewController(projectExtensionsController, animated: true)
		}
		
		if cells[index] == addressesCell {
			let projectAddressesController = ProjectAddressController(style: .insetGrouped)
			projectAddressesController.project = delegate?.project
			delegate?.navigationController?.pushViewController(projectAddressesController, animated: true)
		}
	}
	
	override func initialize() {
		archive = delegate?.project.imdfArchive
		reloadOnAppear()
	}
	
	override func reloadOnAppear() {
		resetExtensionCount()
		resetAddressesCount()
	}
}
