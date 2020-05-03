//
//  ProjectCreateController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectCreateController: DetailTableViewController {

	var tableViewSections: [[UITableViewCell]] = []
	
	let projectTitleCell		= TextInputTableViewCell(placeholder: Localizable.Project.projectTitle, maxLength: 50)
	let projectDescriptionCell	= TextInputTableViewCell(placeholder: Localizable.Project.projectDescription)
	let projectClientCell		= TextInputTableViewCell(placeholder: Localizable.Project.projectClient)
	let projectCreateCell		= ButtonTableViewCell(title: Localizable.ProjectExplorer.buttonCreate)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configure()
		projectTitleCell.textField.becomeFirstResponder()
	}
	
	private func configure() -> Void {
		title = Localizable.ProjectExplorer.createNewProject
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
		
		//
		// Configure the table view itself
		tableView.rowHeight = UITableView.automaticDimension
		tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
		
		//
		// Prepare the table view sections
		tableViewSections.append([projectTitleCell, projectDescriptionCell])
		tableViewSections.append([projectClientCell])
		tableViewSections.append([projectCreateCell])
		
		projectTitleCell.textField.addTarget(self, action: #selector(didUpdateProjectTitle), for: .editingChanged)
		projectCreateCell.cellButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
		
		didUpdateProjectTitle(projectTitleCell.textField)
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
			ProjectExplorerHandler.shared.insert(at: IndexPath(row: 0, section: ProjectExplorerHandler.SectionCategory.projects.rawValue), with: .fade)
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
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return tableViewSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableViewSections[section].count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableViewSections[indexPath.section][indexPath.row]
	}
}
