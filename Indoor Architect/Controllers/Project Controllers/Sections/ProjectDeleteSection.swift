//
//  ProjectDeleteSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectDeleteSection: ProjectSection {
	
	let deleteButtonCell = ButtonTableViewCell(title: Localizable.Project.buttonDelete)
	
	override init() {
		super.init()
		
		cells.append(deleteButtonCell)
		
		deleteButtonCell.cellButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
	}
	
	@objc private func didTapDelete(_ sender: UIButton) -> Void {
		let project: IMDFProject = Application.currentProject
		
		guard let indexPath = ProjectExplorerHandler.shared.indexPath(for: project) else {
			return
		}
		
		guard let _ = try? project.delete() else {
			return
		}
		
		IMDFProject.projects.removeAll { (imdfProject) -> Bool in
			return imdfProject.manifest.uuid == project.manifest.uuid
		}
		
		ProjectExplorerHandler.shared.delete(at: indexPath, with: .left)
		Application.masterController.showDetailViewController(WelcomeController(), sender: nil)
		Application.currentProject = nil
	}
	
	override func titleForFooter() -> String? {
		return Localizable.Project.buttonDeleteDescription
	}
}
