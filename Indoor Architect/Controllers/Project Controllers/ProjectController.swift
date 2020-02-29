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
	
	let generalSection = ProjectGeneralSection()
	
	var project: IMDFProject! {
		didSet {
			reloadProjectDetails()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = project.manifest.title
		
		sections.append(generalSection)
		
		for projectSection in sections {
			projectSection.delegate = self
			projectSection.initialize()
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
}
