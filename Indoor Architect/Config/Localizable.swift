//
//  Localized.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct Localizable {
	
	struct ProjectExplorer {
	
		static let searchBarPlaceholder		= NSLocalizedString("projectExplorer.searchBarPlaceholder", comment: "")
		static let sectionTitleProjects		= NSLocalizedString("projectExplorer.sectionTitleProjects", comment: "")
		static let sectionTitleResources	= NSLocalizedString("projectExplorer.sectionTitleResources", comment: "")
		
		static let infoNoProject			= NSLocalizedString("projectExplorer.infoNoProject", comment: "")
		
		struct CreateProject {
			static let title				= NSLocalizedString("projectExplorer.createProject.title", comment: "")
			static let buttonCreate			= NSLocalizedString("projectExplorer.createProject.buttonCreate", comment: "")
			static let buttonCancel			= NSLocalizedString("projectExplorer.createProject.buttonCancel", comment: "")
			static let projectTitle			= NSLocalizedString("projectExplorer.createProject.projectTitle", comment: "")
			static let projectDescription	= NSLocalizedString("projectExplorer.createProject.projectDescription", comment: "")
			static let projectClient		= NSLocalizedString("projectExplorer.createProject.projectClient", comment: "")
		}
		
	}
}
