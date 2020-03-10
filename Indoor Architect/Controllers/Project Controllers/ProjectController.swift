//
//  ProjectController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectController: UITableViewController {

	let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
	
	var sections: [ProjectSection] = []
	
	let generalSection	= ProjectGeneralSection()
	let metaInfoSection	= ProjectMetaInfoSection()
	let actionSection	= ProjectActionSection()
	let archiveSection	= ProjectArchiveSection()
	let deleteSection	= ProjectDeleteSection()
	
	var project: IMDFProject! {
		didSet {
			reloadProjectDetails()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = project.manifest.title
		tableView.rowHeight = UITableView.automaticDimension
		
		sections.append(generalSection)
		sections.append(metaInfoSection)
		sections.append(actionSection)
		sections.append(archiveSection)
		sections.append(deleteSection)
		
		for projectSection in sections {
			projectSection.delegate = self
			projectSection.initialize()
		}
		
		//
		// If the project has unsaved changes the save-button will be shown
		if project.hasChangesToStoredVersion {
			projectDetailsDidChange()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		for projectSection in sections {
			projectSection.reloadOnAppear()
		}
	}
	
	/// Reloads the data from the passed project instance
	private func reloadProjectDetails() -> Void {
		title = project.manifest.title
		generalSection.projectTitleCell.setText(project.manifest.title)
		generalSection.projectDescriptionCell.setText(project.manifest.description)
		generalSection.projectClientCell.setText(project.manifest.client)
	}
	
	/// Enables the save button in the navigation bar so the changes can be stored
	func projectDetailsDidChange() -> Void {
		if navigationItem.rightBarButtonItem == saveBarButtonItem {
			return
		}
		
		navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
	}
	
	/// Tries to save the project and disables the save button
	/// - Parameter sender: The button which was tapped
	@objc private func saveProject(_ sender: UIBarButtonItem) -> Void {
		do {
			navigationItem.setRightBarButton(nil, animated: true)
			try project.save()
			ProjectExplorerHandler.shared.reloadData()
		} catch {
			print(error)
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].numberOfRows()
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].titleForHeader()
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return sections[section].titleForFooter()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return sections[indexPath.section].cellForRow(at: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		return sections[indexPath.section].accessoryButtonTappedForRow(at: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		return sections[indexPath.section].didSelectRow(at: indexPath.row)
	}
}
