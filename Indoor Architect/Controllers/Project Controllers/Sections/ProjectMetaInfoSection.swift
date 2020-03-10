//
//  ProjectMetaInfoSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectMetaInfoSection: ProjectSection {
	
	let createdAtCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	let updatedAtCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	override init() {
		super.init()
		cells.append(createdAtCell)
		cells.append(updatedAtCell)
		
		createdAtCell.selectionStyle	= .none
		createdAtCell.textLabel?.text	= Localizable.ProjectExplorer.Project.created
		createdAtCell.backgroundColor	= Color.lightStyleCellBackground
		
		updatedAtCell.selectionStyle	= .none
		updatedAtCell.textLabel?.text	= Localizable.ProjectExplorer.Project.updated
		updatedAtCell.backgroundColor	= Color.lightStyleCellBackground
	}
	
	private func prettyDate(_ date: Date?) -> String {
		guard let date = date else {
			return Localizable.General.missingInformation
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .medium
		return dateFormatter.string(from: date)
	}
	
	func setCreatedAt(date: Date?) -> Void {
		createdAtCell.detailTextLabel?.text = prettyDate(date)
	}
	
	func setUpdatedAt(date: Date?) -> Void {
		updatedAtCell.detailTextLabel?.text = prettyDate(date)
	}
	
	override func initialize() {
		setCreatedAt(date: delegate?.project.manifest.createdAt)
		setUpdatedAt(date: delegate?.project.manifest.updatedAt)
	}
}
