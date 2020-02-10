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
	
	let projectTitleCell		= TextInputTableViewCell(placeholder: "Project Title")
	let projectDescriptionCell	= TextInputTableViewCell(placeholder: "Description")
	let projectClientCell		= TextInputTableViewCell(placeholder: "Client")
	let projectCreateCell		= ButtonTableViewCell(title: "Create Project")
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = Localizable.ProjectExplorer.CreateProject.title
		
		navigationItem.leftBarButtonItem	= UIBarButtonItem(title: Localizable.ProjectExplorer.CreateProject.buttonCancel, style: .plain, target: self, action: #selector(didTapCancel))
		
		tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
		
		tableViewSections.append([projectTitleCell, projectDescriptionCell])
		tableViewSections.append([projectClientCell])
		tableViewSections.append([projectCreateCell])
		
		projectTitleCell.textField.addTarget(self, action: #selector(didUpdateProjectTitle), for: .editingChanged)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		tableView.removeObserver(self, forKeyPath: "contentSize")
	}
	
	@objc func didTapCancel(_ sender: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		self.preferredContentSize = tableView.contentSize
	}
	
	@objc func didUpdateProjectTitle(_ sender: UITextField) -> Void {
		projectCreateCell.cellButton.isEnabled = sender.text?.count ?? 0 > 0
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
