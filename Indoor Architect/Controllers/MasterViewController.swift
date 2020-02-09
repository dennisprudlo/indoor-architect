//
//  MasterViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

	let projectSearchController = UISearchController(searchResultsController: nil)
	
	var tableViewSections: [(title: String, cells: [UITableViewCell])] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configure()
    }
	
	private func configure() -> Void {
	
		//
		// Configure master view title
		navigationController?.navigationBar.prefersLargeTitles = true
		title = Application.title
		
		//
		// Configure search controller and search bar
		projectSearchController.obscuresBackgroundDuringPresentation	= false
		projectSearchController.hidesNavigationBarDuringPresentation	= true
		projectSearchController.searchBar.placeholder					= Localizable.ProjectExplorer.searchBarPlaceholder
		navigationItem.searchController									= projectSearchController
	
		//
		// Configure navigation bar buttons
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
		
		//
		// Configure content table view
		tableView.separatorStyle = .none
		
		tableViewSections = [
			(title: Localizable.ProjectExplorer.sectionTitleProjects, cells: []),
			(title: Localizable.ProjectExplorer.sectionTitleResources, cells: [])
		]
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
		return tableViewSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableViewSections[section].cells.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableViewSections[indexPath.section].cells[indexPath.row]
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return tableViewSections[section].title
	}
}
