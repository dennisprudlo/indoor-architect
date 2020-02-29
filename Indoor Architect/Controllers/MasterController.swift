//
//  MasterController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MasterController: UITableViewController {

	let projectSearchController = UISearchController(searchResultsController: nil)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		Application.masterController = self
		
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
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
		
		//
		// Configure content table view
		tableView.dataSource					= ProjectExplorerHandler.shared
		tableView.delegate						= ProjectExplorerHandler.shared
		tableView.separatorStyle				= .none
		tableView.rowHeight						= UITableView.automaticDimension
		tableView.estimatedRowHeight			= 64
		tableView.sectionHeaderHeight			= UITableView.automaticDimension
		tableView.estimatedSectionHeaderHeight	= 36;
		
		ProjectExplorerHandler.shared.tableView	= tableView
	}
	
	@objc func didTapAdd(_ sender: UIBarButtonItem) -> Void {
		let createProjectViewController = UINavigationController(rootViewController: ProjectCreateController(style: .insetGrouped))
		createProjectViewController.modalPresentationStyle = .popover
		createProjectViewController.popoverPresentationController?.barButtonItem = sender
		
		present(createProjectViewController, animated: true, completion: nil)
	}
}
