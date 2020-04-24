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
	
	let addressesCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	override init() {
		super.init()
		
		addressesCell.backgroundColor			= Color.lightStyleCellBackground
		addressesCell.accessoryType				= .disclosureIndicator

		cells.append(addressesCell)
	
		addressesCell.textLabel?.text = Localizable.Project.addresses
	}
	
	func resetAddressesCount() -> Void {
		guard let addressesCount = archive?.addresses.count else {
			addressesCell.detailTextLabel?.text = Localizable.General.none
			return
		}
		
		if addressesCount == 0 {
			addressesCell.detailTextLabel?.text = Localizable.General.none
			return
		}
		
		addressesCell.detailTextLabel?.text = "\(addressesCount)"
	}
	
	override func titleForHeader() -> String? {
		return Localizable.Project.archiveSectionTitle
	}
	
	override func didSelectRow(at index: Int) {
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
		resetAddressesCount()
	}
}
