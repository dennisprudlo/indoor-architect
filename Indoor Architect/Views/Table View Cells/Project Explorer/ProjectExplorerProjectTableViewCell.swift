//
//  ProjectExplorerProjectTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerProjectTableViewCell: LeadingIconTableViewCell {
	
	var project: IMDFProject?

	init(project: IMDFProject) {
		super.init(title: project.manifest.title, icon: Icon.folder)
	
		self.project = project
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
