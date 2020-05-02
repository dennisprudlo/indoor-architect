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
		static let missingInformation	= NSLocalizedString("general.missingInformation", comment: "")
		static let add					= NSLocalizedString("general.add", comment: "")
		static let delete				= NSLocalizedString("general.delete", comment: "")
		static let remove				= NSLocalizedString("general.remove", comment: "")
		static let cancel				= NSLocalizedString("general.cancel", comment: "")
		static let none					= NSLocalizedString("general.none", comment: "")
		static let actionConfirmation	= NSLocalizedString("general.actionConfirmation", comment: "")
	}
	
	struct Project {
		static let buttonDelete				= NSLocalizedString("project.buttonDelete", comment: "")
		static let buttonDeleteDescription	= NSLocalizedString("project.buttonDeleteDescription", comment: "")
		static let projectTitle				= NSLocalizedString("project.projectTitle", comment: "")
		static let projectDescription		= NSLocalizedString("project.projectDescription", comment: "")
		static let projectClient			= NSLocalizedString("project.projectClient", comment: "")
		static let created					= NSLocalizedString("project.created", comment: "")
		static let updated					= NSLocalizedString("project.updated", comment: "")
		static let editIndoorMap			= NSLocalizedString("project.editIndoorMap", comment: "")
		static let exportImdfArchive		= NSLocalizedString("project.exportImdfArchive", comment: "")
		static let archiveSectionTitle		= NSLocalizedString("project.archiveSectionTitle", comment: "")
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
	}
	
	struct Extension {
		static let title				= NSLocalizedString("extensions.title", comment: "")
		static let addExtension			= NSLocalizedString("extensions.addExtension", comment: "")
		static let editExtension		= NSLocalizedString("extensions.editExtension", comment: "")
		static let removeExtensionInfo	= NSLocalizedString("extensions.removeExtensionInfo", comment: "")
		static let provider				= NSLocalizedString("extensions.provider", comment: "")
		static let providerDescription	= NSLocalizedString("extensions.providerDescription", comment: "")
		static let name					= NSLocalizedString("extensions.name", comment: "")
		static let nameDescription		= NSLocalizedString("extensions.nameDescription", comment: "")
		static let version				= NSLocalizedString("extensions.version", comment: "")
		static let versionDescription	= NSLocalizedString("extensions.versionDescription", comment: "")
	}
	
	struct Address {
		static let title						= NSLocalizedString("address.title", comment: "")
		static let addAddress					= NSLocalizedString("address.addAddress", comment: "")
		static let editAddress					= NSLocalizedString("address.editAddress", comment: "")
		static let titlePreviouslyUsed			= NSLocalizedString("address.titlePreviouslyUsed", comment: "")
		static let removeAddressInfo			= NSLocalizedString("address.removeAddressInfo", comment: "")
		static let addressDescription			= NSLocalizedString("address.addressDescription", comment: "")
		static let placeholderAddress			= NSLocalizedString("address.placeholderAddress", comment: "")
		static let placeholderCountry			= NSLocalizedString("address.placeholderCountry", comment: "")
		static let placeholderProvince			= NSLocalizedString("address.placeholderProvince", comment: "")
		static let placeholderLocality			= NSLocalizedString("address.placeholderLocality", comment: "")
		static let postalCode					= NSLocalizedString("address.postalCode", comment: "")
		static let postalCodeDescription		= NSLocalizedString("address.postalCodeDescription", comment: "")
		static let placeholderCode				= NSLocalizedString("address.placeholderCode", comment: "")
		static let placeholderExtension			= NSLocalizedString("address.placeholderExtension", comment: "")
		static let placeholderVanity			= NSLocalizedString("address.placeholderVanity", comment: "")
		static let unit							= NSLocalizedString("address.unit", comment: "")
		static let unitDescription				= NSLocalizedString("address.unitDescription", comment: "")
		static let placeholderUnit				= NSLocalizedString("address.placeholderUnit", comment: "")
		static let localitySearchBarPlaceholder = NSLocalizedString("address.localitySearchBarPlaceholder", comment: "")
	}
}
