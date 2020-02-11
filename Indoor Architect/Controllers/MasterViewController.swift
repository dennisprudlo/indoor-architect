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
		Application.masterViewController = self
		
		configure()
		reloadProjects()
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
		tableView.separatorStyle				= .none
		tableView.rowHeight						= UITableView.automaticDimension
		tableView.estimatedRowHeight			= 64
		tableView.sectionHeaderHeight			= UITableView.automaticDimension
		tableView.estimatedSectionHeaderHeight	= 36;
		
		tableViewSections = [
			(title: Localizable.ProjectExplorer.sectionTitleProjects, cells: []),
			(title: Localizable.ProjectExplorer.sectionTitleResources, cells: [])
		]
	}
	
	@objc func didTapAdd(_ sender: UIBarButtonItem) -> Void {
		let createProjectViewController = UINavigationController(rootViewController: CreateProjectViewController(style: .insetGrouped))
		createProjectViewController.modalPresentationStyle = .popover
		createProjectViewController.popoverPresentationController?.barButtonItem = sender
		
		present(createProjectViewController, animated: true, completion: nil)
	}
	
	func reloadProjects() -> Void {
		tableViewSections[0].cells = []
		IMDFProject.projects.forEach { (project) in
			let projectCell = ProjectExplorerTableViewCell(title: project.manifest.title, icon: Icon.apple)
			tableViewSections[0].cells.append(projectCell)
		}
		
		tableView.beginUpdates()
		tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
		tableView.endUpdates()
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
	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let canvasAction = UIContextualAction(style: .normal, title: "Canvas", handler: { (action, view, completion) in
			completion(false)
		})
		canvasAction.backgroundColor = .systemBlue
		
		return UISwipeActionsConfiguration(actions: [canvasAction])
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
			completion(false)
		})
		deleteAction.backgroundColor = Color.primary
		
		let exportAction = UIContextualAction(style: .normal, title: "Export IMDF", handler: { (action, view, completion) in
			completion(false)
		})
		
		return UISwipeActionsConfiguration(actions: [deleteAction, exportAction])
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return ProjectExplorerSectionHeaderView(title: tableViewSections[section].title, firstSection: section == 0)
	}
}
