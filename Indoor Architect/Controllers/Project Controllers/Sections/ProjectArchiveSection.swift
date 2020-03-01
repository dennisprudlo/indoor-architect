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
	
	let customExtensionsCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	override init() {
		super.init()
		customExtensionsCell.accessoryType = .disclosureIndicator
		
		cells.append(customExtensionsCell)
		
		customExtensionsCell.textLabel?.text = Localizable.ProjectExplorer.Project.extensions
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
	
	override func titleForHeader() -> String? {
		return Localizable.ProjectExplorer.Project.archiveSectionTitle
	}
	
	override func didSelectRow(at index: Int) {
		if cells[index] == customExtensionsCell {
			let projectExtensionsController = ProjectExtensionsController(style: .insetGrouped)
			projectExtensionsController.project = delegate?.project
			delegate?.navigationController?.pushViewController(projectExtensionsController, animated: true)
		}
	}
	
	override func initialize() {
		archive = delegate?.project.imdfArchive
		resetExtensionCount()
	}
	
	override func reloadOnAppear() {
		resetExtensionCount()
	}
}
