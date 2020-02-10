//
//  CreateProjectViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class CreateProjectViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = Localizable.ProjectExplorer.CreateProject.title
		
		navigationItem.leftBarButtonItem	= UIBarButtonItem(title: Localizable.ProjectExplorer.CreateProject.buttonCancel, style: .plain, target: self, action: #selector(didTapCancel))
		navigationItem.rightBarButtonItem	= UIBarButtonItem(title: Localizable.ProjectExplorer.CreateProject.buttonCreate, style: .done, target: self, action: #selector(didTapCreate))
	}
	
	@objc func didTapCancel(_ sender: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func didTapCreate(_ sender: UIBarButtonItem) -> Void {
		
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
