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
	
	let addressesCell	= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let anchorsCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	override init() {
		super.init()
		
		[addressesCell, anchorsCell].forEach { (archiveCell) in
			archiveCell.backgroundColor	= Color.lightStyleCellBackground
			archiveCell.accessoryType	= .disclosureIndicator
			cells.append(archiveCell)
		}
	
		addressesCell.textLabel?.text = Localizable.Address.title
		anchorsCell.textLabel?.text = "Anchors"
	}
	
	func resetCellCount(cell: UITableViewCell, count: Int?) -> Void {
		guard let safeCount = count, safeCount > 0 else {
			cell.detailTextLabel?.text = Localizable.General.none
			return
		}
		
		cell.detailTextLabel?.text = "\(safeCount)"
	}
	
	override func titleForHeader() -> String? {
		return Localizable.Project.archiveSectionTitle
	}
	
	override func didSelectRow(at index: Int) {
		if cells[index] == addressesCell {
			let projectAddressesController = ProjectAddressController(style: .insetGrouped)
			projectAddressesController.project = delegate?.project
			delegate?.navigationController?.pushViewController(projectAddressesController, animated: true)
		} else if cells[index] == anchorsCell {
			let anchorsListController = AnchorsListController(style: .insetGrouped)
			anchorsListController.project = delegate?.project
			delegate?.navigationController?.pushViewController(anchorsListController, animated: true)
		}
	}
	
	override func initialize() {
		archive = delegate?.project.imdfArchive
		reloadOnAppear()
	}
	
	override func reloadOnAppear() {
		resetCellCount(cell: addressesCell, count: archive?.addresses.count)
		resetCellCount(cell: anchorsCell, count: archive?.anchors.count)
	}
}
