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
		
		struct CreateProject {
			static let title		= NSLocalizedString("projectExplorer.createProject.title", comment: "")
			static let buttonCreate	= NSLocalizedString("projectExplorer.createProject.buttonCreate", comment: "")
			static let buttonCancel	= NSLocalizedString("projectExplorer.createProject.buttonCancel", comment: "")
		}
		
	}
}
