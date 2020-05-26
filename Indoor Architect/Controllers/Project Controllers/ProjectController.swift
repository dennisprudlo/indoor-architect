//
//  ProjectController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectController: DetailTableViewController {

	lazy var saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
	
	var sections: [ProjectSection] = []
	
	let generalSection	= ProjectGeneralSection()
	let metaInfoSection	= ProjectMetaInfoSection()
	let actionSection	= ProjectActionSection()
	let archiveSection	= ProjectArchiveSection()
	let deleteSection	= ProjectDeleteSection()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		reloadProjectDetails()
		
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
		toggleSaveButton()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		for projectSection in sections {
			projectSection.reloadOnAppear()
		}
	}
	
	/// Reloads the data from the passed project instance
	private func reloadProjectDetails() -> Void {
		let manifest = Application.currentProject.manifest
		
		print(ProjectManager.shared.url(forPathComponent: .rootDirectory, inProjectWithUuid: manifest.uuid).path)
		
		title = manifest.title
		generalSection.projectTitleCell.setText(manifest.title)
		generalSection.projectDescriptionCell.setText(manifest.description)
		generalSection.projectClientCell.setText(manifest.client)
	}
	
	/// Enables the save button in the navigation bar so the changes can be stored
	func toggleSaveButton() -> Void {
		if generalSection.hasChangesToCurrentManifest() {
			if navigationItem.rightBarButtonItem == saveBarButtonItem {
				return
			}
			
			navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
		} else {
			navigationItem.setRightBarButton(nil, animated: true)
		}
	}
	
	/// Tries to save the project and disables the save button
	/// - Parameter sender: The button which was tapped
	@objc public func saveProject(_ sender: UIBarButtonItem) -> Void {
		do {
			let data = generalSection.getProcessedInputs()
			Application.currentProject.manifest.title		= data.title
			Application.currentProject.manifest.description	= data.description
			Application.currentProject.manifest.client		= data.client
			
			try Application.currentProject.save()
			ProjectExplorerHandler.shared.reloadData()
			
			navigationItem.setRightBarButton(nil, animated: true)
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
