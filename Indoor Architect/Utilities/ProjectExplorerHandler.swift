//
//  ProjectExplorerHandler.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/15/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

/// The `ProjectExplorerHandler` is responsible for inserting and removing cells that are visible in the project explorer.
/// It manages the sections and the cell behavior
class ProjectExplorerHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
	
	static let shared: ProjectExplorerHandler = ProjectExplorerHandler()
	
	/// The section type defines a whole section in the project explorer. Each section has a title, a text for when the section has no items, an array with all
	/// cells currently visible in the section and a function that reloads the section data
	typealias Section = (title: String, emptyTitle: String, cells: [UITableViewCell], reload: () -> [UITableViewCell])
	
	/// The array that holds all sections of the project explorer
	var sections: [Section] = []
	
	/// A reference to the tableView that is being handled
	var tableView: UITableView!
	
	/// A category reference for the different type of sections
	enum SectionCategory: Int {
		case projects
		case guides
		case resources
	}
	
	override init() {
		super.init()
		
		let projects: Section = (
			title:		Localizable.ProjectExplorer.sectionTitleProjects,
			emptyTitle: Localizable.ProjectExplorer.infoNoProject,
			cells:		[],
			reload:	{
				var cells: [UITableViewCell] = []
				IMDFProject.projects.forEach { (project) in
					let projectCell = ProjectExplorerTableViewCell(title: project.manifest.title, icon: Icon.apple)
					projectCell.project = project
					cells.append(projectCell)
				}
				return cells
			}
		)
		
		let guides: Section = (
			title:		"Guides",
			emptyTitle: "not set",
			cells:		[],
			reload:	{
				return []
			}
		)
		
		let resources: Section = (
			title:		Localizable.ProjectExplorer.sectionTitleResources,
			emptyTitle: "not set",
			cells:		[],
			reload:	{
				return []
			}
		)
		
		sections.append(projects)
		sections.append(guides)
		sections.append(resources)
		
		reloadSections()
	}
	
	/// Prepares the table view to animate the insertion of an item
	/// - Parameters:
	///   - indexPath: The index path where the item is being inserted
	///   - animation: The animation for the insertion
	func insert(at indexPath: IndexPath, with animation: UITableView.RowAnimation) -> Void {
		if sections.count <= indexPath.section {
			return
		}
		
		tableView.beginUpdates()
		
		if sections[indexPath.section].cells.count == 0 {
			tableView.deleteRows(at: [IndexPath(row: 0, section: indexPath.section)], with: animation)
		}
		tableView.insertRows(at: [indexPath], with: animation)
		
		reloadSections(justFor: indexPath.section)
		
		tableView.endUpdates()
	}
	
	/// Preparest the table view to animate the deletion of an item
	/// - Parameters:
	///   - indexPath: The index path where the item is being deleted from
	///   - animation: The animation for the deletion
	func delete(at indexPath: IndexPath, with animation: UITableView.RowAnimation) -> Void {
		if sections.count <= indexPath.section {
			return
		}
		
		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .left)
		reloadSections(justFor: indexPath.section)
		
		if sections[indexPath.section].cells.count == 0 {
			tableView.insertRows(at: [indexPath], with: animation)
		}
		
		tableView.endUpdates()
	}
	
	/// Reloads the data for the sections or a single section in particular
	/// - Parameter section: The id of the section if just one section should reload its data
	private func reloadSections(justFor section: Int? = nil) -> Void {
		if section != nil && sections.count > section! {
			sections[section!].cells = sections[section!].reload()
			return
		}
		
		for section in 0..<sections.count {
			sections[section].cells = sections[section].reload()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = sections[section].cells.count
		return count == 0 ? 1 : count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let count = sections[indexPath.section].cells.count
		if count > 0 {
			return sections[indexPath.section].cells[indexPath.row]
		} else {
			return ProjectExplorerPlaceholderCell(title: sections[indexPath.section].emptyTitle)
		}
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		if sections[indexPath.section].cells.count == 0 {
			return nil
		}

		if indexPath.section == SectionCategory.projects.rawValue {
			let canvasAction = UIContextualAction(style: .normal, title: "Canvas", handler: { (action, view, completion) in
				completion(false)
			})
			canvasAction.backgroundColor = .systemBlue
			canvasAction.image = Icon.map
			
			return UISwipeActionsConfiguration(actions: [canvasAction])
		}
		
		return nil
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		if sections[indexPath.section].cells.count == 0 {
			return nil
		}
		
		if indexPath.section == SectionCategory.projects.rawValue {
			let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
				if indexPath.row >= IMDFProject.projects.count {
					completion(false)
					return
				}
				
				let project = IMDFProject.projects[indexPath.row]
				
				guard let _ = try? project.delete() else {
					completion(false)
					return
				}
				
				IMDFProject.projects.removeAll { (imdfProject) -> Bool in
					return imdfProject.manifest.uuid == project.manifest.uuid
				}
				self.delete(at: indexPath, with: .left)
				
				completion(true)
			})
			deleteAction.backgroundColor = Color.primary
			deleteAction.image = Icon.trash
			
			let exportAction = UIContextualAction(style: .normal, title: "Export IMDF", handler: { (action, view, completion) in
				completion(false)
			})
			exportAction.image = Icon.download
			
			return UISwipeActionsConfiguration(actions: [deleteAction, exportAction])
		}

		return nil
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return ProjectExplorerSectionHeaderView(title: sections[section].title)
	}
}