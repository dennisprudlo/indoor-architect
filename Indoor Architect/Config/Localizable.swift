//
//  Localized.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct Localizable {
	
	struct General {
		static let missingInformation = NSLocalizedString("general.missingInformation", comment: "")
	}
	
	struct ProjectExplorer {
	
		static let searchBarPlaceholder		= NSLocalizedString("projectExplorer.searchBarPlaceholder", comment: "")
		static let sectionTitleProjects		= NSLocalizedString("projectExplorer.sectionTitleProjects", comment: "")
		static let sectionEmptyProjects		= NSLocalizedString("projectExplorer.sectionEmptyProjects", comment: "")
		static let sectionTitleGuides		= NSLocalizedString("projectExplorer.sectionTitleGuides", comment: "")
		static let sectionEmptyGuides		= NSLocalizedString("projectExplorer.sectionEmptyGuides", comment: "")
		static let sectionTitleResources	= NSLocalizedString("projectExplorer.sectionTitleResources", comment: "")
		static let sectionEmptyResources	= NSLocalizedString("projectExplorer.sectionEmptyResources", comment: "")
		static let createNewProject			= NSLocalizedString("projectExplorer.createNewProject", comment: "")
		static let buttonCreate				= NSLocalizedString("projectExplorer.buttonCreate", comment: "")
		
		struct Project {
			static let buttonDelete				= NSLocalizedString("projectExplorer.project.buttonDelete", comment: "")
			static let buttonDeleteDescription	= NSLocalizedString("projectExplorer.project.buttonDeleteDescription", comment: "")
			static let projectTitle				= NSLocalizedString("projectExplorer.project.projectTitle", comment: "")
			static let projectDescription		= NSLocalizedString("projectExplorer.project.projectDescription", comment: "")
			static let projectClient			= NSLocalizedString("projectExplorer.project.projectClient", comment: "")
			static let projectClientHelp		= NSLocalizedString("projectExplorer.project.projectClientHelp", comment: "")
			static let created					= NSLocalizedString("projectExplorer.project.created", comment: "")
			static let updated					= NSLocalizedString("projectExplorer.project.updated", comment: "")
			static let editIndoorMap			= NSLocalizedString("projectExplorer.project.editIndoorMap", comment: "")
			static let exportImdfArchive		= NSLocalizedString("projectExplorer.project.exportImdfArchive", comment: "")
			static let archiveSectionTitle		= NSLocalizedString("projectExplorer.project.archiveSectionTitle", comment: "")
			static let extensions				= NSLocalizedString("projectExplorer.project.extensions", comment: "")
			static let addExtensionTitle		= NSLocalizedString("projectExplorer.project.addExtensionTitle", comment: "")
			static let extensionProvider		= NSLocalizedString("projectExplorer.project.extensionProvider", comment: "")
			static let extensionName			= NSLocalizedString("projectExplorer.project.extensionName", comment: "")
			static let extensionVersion			= NSLocalizedString("projectExplorer.project.extensionVersion", comment: "")
		}
		
	}
}
