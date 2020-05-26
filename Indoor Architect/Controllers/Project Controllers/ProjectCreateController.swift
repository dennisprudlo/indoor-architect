//
//  ProjectCreateController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectCreateController: IATableViewController {
	
	let projectTitleCell		= TextInputTableViewCell(placeholder: Localizable.Project.projectTitle)
	let projectDescriptionCell	= TextInputTableViewCell(placeholder: Localizable.Project.projectDescription)
	let projectClientCell		= TextInputTableViewCell(placeholder: Localizable.Project.projectClient)
	let projectCreateCell		= ButtonTableViewCell(title: Localizable.ProjectExplorer.buttonCreate)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = Localizable.ProjectExplorer.createNewProject
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
		
		//
		// Configure the table view itself
		tableView.rowHeight = UITableView.automaticDimension
		tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
		
		projectTitleCell.textField.addTarget(self,		action: #selector(didUpdateProjectTitle),	for: .editingChanged)
		projectCreateCell.cellButton.addTarget(self,	action: #selector(didTapCreate),			for: .touchUpInside)
		
		//
		// Prepare the table view sections
		tableViewSections.append((title: nil, description: nil, cells: [projectTitleCell, projectDescriptionCell]))
		tableViewSections.append((title: nil, description: nil, cells: [projectClientCell]))
		tableViewSections.append((title: nil, description: nil, cells: [projectCreateCell]))
		
		didUpdateProjectTitle(projectTitleCell.textField)
		
		projectTitleCell.textField.becomeFirstResponder()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		tableView.removeObserver(self, forKeyPath: "contentSize")
	}
	
	/// Dismiss the create project modal when tapping cancel
	/// - Parameter sender: The bar button item that was tapped
	@objc func didTapCancel(_ sender: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	/// Creates a new project when tapping the create button
	/// - Parameter sender: The button that was tapped
	@objc func didTapCreate(_ sender: UIButton) -> Void {
		guard let title = projectTitleCell.textField.text else {
			return
		}
	
		//
		// First, get an unused UUID which we can use as the project identifier
		let unusedUuid					= ProjectManager.shared.getUnusedUuid()
		
		do {
			//
			// Try to create the project
			let project						= try ProjectManager.shared.create(projectWith: unusedUuid, title: title)
			project.manifest.description	= projectDescriptionCell.textField.text
			project.manifest.client			= projectClientCell.textField.text
			
			//
			// Try to create the folder structure and files for the created project
			try project.save()
			
			//
			// Add the project to the global projects array and animate the insertion in the table view
			IMDFProject.projects.insert(project, at: 0)
			
			let projectIndexPath = IndexPath(row: 0, section: ProjectExplorerHandler.SectionCategory.projects.rawValue)
			ProjectExplorerHandler.shared.insert(at: projectIndexPath, with: .fade)
			ProjectExplorerHandler.shared.tableView(ProjectExplorerHandler.shared.tableView, didSelectRowAt: projectIndexPath)
			ProjectExplorerHandler.shared.tableView.selectRow(at: projectIndexPath, animated: true, scrollPosition: .none)
			
			dismiss(animated: true, completion: nil)
		} catch {
			print(error)
		}
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		self.preferredContentSize = tableView.contentSize
	}
	
	/// Enable or disable the create button when the project title changes
	/// - Parameter sender: The text field where the content was changed
	@objc func didUpdateProjectTitle(_ sender: UITextField) -> Void {
		projectCreateCell.setEnabled(sender.text?.count ?? 0 > 0)
	}
}
