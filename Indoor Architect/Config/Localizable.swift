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
		static let sectionEmptyProjects		= NSLocalizedString("projectExplorer.sectionEmptyProjects", comment: "")
		static let sectionTitleGuides		= NSLocalizedString("projectExplorer.sectionTitleGuides", comment: "")
		static let sectionEmptyGuides		= NSLocalizedString("projectExplorer.sectionEmptyGuides", comment: "")
		static let sectionTitleResources	= NSLocalizedString("projectExplorer.sectionTitleResources", comment: "")
		static let sectionEmptyResources	= NSLocalizedString("projectExplorer.sectionEmptyResources", comment: "")
		
		struct Project {
			static let title				= NSLocalizedString("projectExplorer.project.title", comment: "")
			static let buttonCreate			= NSLocalizedString("projectExplorer.project.buttonCreate", comment: "")
			static let buttonCancel			= NSLocalizedString("projectExplorer.project.buttonCancel", comment: "")
			static let projectTitle			= NSLocalizedString("projectExplorer.project.projectTitle", comment: "")
			static let projectDescription	= NSLocalizedString("projectExplorer.project.projectDescription", comment: "")
			static let projectClient		= NSLocalizedString("projectExplorer.project.projectClient", comment: "")
			static let editIndoorMap		= NSLocalizedString("projectExplorer.project.editIndoorMap", comment: "")
			static let exportImdfArchive	= NSLocalizedString("projectExplorer.project.exportImdfArchive", comment: "")
		}
		
	}
}
