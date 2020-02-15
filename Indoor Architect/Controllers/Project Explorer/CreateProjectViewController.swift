//
//  CreateProjectViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class CreateProjectViewController: UITableViewController {

	var tableViewSections: [[UITableViewCell]] = []
	
	let projectTitleCell		= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.CreateProject.projectTitle)
	let projectDescriptionCell	= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.CreateProject.projectDescription)
	let projectClientCell		= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.CreateProject.projectClient)
	let projectCreateCell		= ButtonTableViewCell(title: Localizable.ProjectExplorer.CreateProject.buttonCreate)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configure()
	}
	
	private func configure() -> Void {
		title = Localizable.ProjectExplorer.CreateProject.title
		
		navigationItem.leftBarButtonItem	= UIBarButtonItem(title: Localizable.ProjectExplorer.CreateProject.buttonCancel, style: .plain, target: self, action: #selector(didTapCancel))
		
		//
		// Configure the table view itself
		tableView.rowHeight = 44
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
	
	@objc func didTapCancel(_ sender: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func didTapCreate(_ sender: UIButton) -> Void {
		guard let title = projectTitleCell.textField.text else {
			return
		}
	
		let unusedUuid					= ProjectManager.shared.getUnusedUuid()
		
		let project						= IMDFProject(withUuid: unusedUuid, title: title)
		project.manifest.description	= projectDescriptionCell.textField.text
		project.manifest.client			= projectClientCell.textField.text
		
		do {
			try project.save()
			
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
	
	@objc func didUpdateProjectTitle(_ sender: UITextField) -> Void {
		if sender.text?.count ?? 0 > 0 {
			projectCreateCell.cellButton.isEnabled = true
			projectCreateCell.cellButton.alpha = 1
		} else {
			projectCreateCell.cellButton.isEnabled = false
			projectCreateCell.cellButton.alpha = 0.5
		}
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
