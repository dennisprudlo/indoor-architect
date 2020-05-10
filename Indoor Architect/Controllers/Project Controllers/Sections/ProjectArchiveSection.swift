//
//  ProjectArchiveSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectArchiveSection: ProjectSection {
	
	let addressesCell	= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let anchorsCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let unitsCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	override init() {
		super.init()
		
		[addressesCell, anchorsCell, unitsCell].forEach { (archiveCell) in
			archiveCell.accessoryType	= .disclosureIndicator
			cells.append(archiveCell)
		}
	
		addressesCell.textLabel?.text = Localizable.Address.title
		anchorsCell.textLabel?.text = "Anchors"
		unitsCell.textLabel?.text = "Units"
	}
	
	func resetCellCount(cell: UITableViewCell, count: Int) -> Void {
		cell.detailTextLabel?.text = count == 0 ? Localizable.General.none : "\(count)"
	}
	
	override func titleForHeader() -> String? {
		return Localizable.Project.archiveSectionTitle
	}
	
	override func didSelectRow(at index: Int) {
		if cells[index] == addressesCell {
			let projectAddressesController = ProjectAddressController(style: .insetGrouped)
			delegate?.navigationController?.pushViewController(projectAddressesController, animated: true)
		} else if cells[index] == anchorsCell {
			let anchorsListController = AnchorsListController(style: .insetGrouped)
			delegate?.navigationController?.pushViewController(anchorsListController, animated: true)
		}
	}
	
	override func initialize() {
		reloadOnAppear()
	}
	
	override func reloadOnAppear() {
		resetCellCount(cell: addressesCell, count: Application.currentProject.imdfArchive.addresses.count)
		resetCellCount(cell: anchorsCell, count: Application.currentProject.imdfArchive.anchors.count)
		resetCellCount(cell: unitsCell, count: Application.currentProject.imdfArchive.units.count)
	}
}
