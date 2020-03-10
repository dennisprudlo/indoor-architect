//
//  IMDFProject.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class IMDFProject {
	
	static var projects: [IMDFProject] = IMDFProject.all()
	
	var hasChangesToStoredVersion: Bool = false {
		didSet {
			if self.hasChangesToStoredVersion {
				manifest.updatedAt = Date()
			}
		}
	}
		
	let manifest: IMDFProjectManifest
	let imdfArchive: IMDFArchive
	
	init(existingWith manifest: IMDFProjectManifest) throws {
		self.manifest		= manifest
		self.imdfArchive	= try IMDFArchive(fromUuid: manifest.uuid)
	}
	
	/// Gets a project by its `UUID`
	/// - Parameter uuid: the projects `UUID`
	static func find(_ uuid: UUID) -> IMDFProject? {
		return ProjectManager.shared.get(withUuid: uuid)
	}
	
	/// Gets all projects available for use
	static func all() -> [IMDFProject] {
		return ProjectManager.shared.getAll().sorted { (firstProject, secondProject) -> Bool in
			return firstProject.manifest.updatedAt > secondProject.manifest.updatedAt
		}
	}
	
	func save() throws -> Void {
		let data = try manifest.data()
		let projectManifestUrl = ProjectManager.shared.url(forPathComponent: .manifest, inProjectWithUuid: manifest.uuid)
		FileManager.default.createFile(atPath: projectManifestUrl.path, contents: data, attributes: nil)
		
		let archiveManifestData = try self.imdfArchive.manifest.encode()
		let archiveManifestUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: .manifest), inProjectWithUuid: manifest.uuid)
		FileManager.default.createFile(atPath: archiveManifestUrl.path, contents: archiveManifestData, attributes: nil)
	}
	
	/// Deletes the project permanentely
	func delete() throws -> Void {
		try ProjectManager.shared.delete(withUuid: manifest.uuid)
	}
	
	func addExtension(provider: String, name: String, version: String) throws -> Void {
		let extensionToAdd = try Extension.make(provider: provider, name: name, version: version)
		self.imdfArchive.manifest.extensions.append(extensionToAdd)
	}
	
	func removeExtension(_ extensionToRemove: Extension) -> Void {
		self.imdfArchive.manifest.extensions.removeAll { (extensionInProject) -> Bool in
			return extensionToRemove.identifier == extensionInProject.identifier
		}
	}
}
