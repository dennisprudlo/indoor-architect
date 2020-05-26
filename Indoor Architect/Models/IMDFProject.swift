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
	
	/// The projects manifest
	let manifest: IMDFProjectManifest
	
	/// The projects IMDF archive
	let imdfArchive: IMDFArchive
	
	/// Initializes an existing project with a given manifest file
	/// - Parameter manifest: The projects manifest
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
	
	/// Saves the project
	func save() throws -> Void {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy	= .iso8601
		encoder.outputFormatting		= .prettyPrinted
		
		//
		// Write the project manifest
		let projectManifestData	= try encoder.encode(manifest)
		let projectManifestUrl	= ProjectManager.shared.url(forPathComponent: .manifest, inProjectWithUuid: manifest.uuid)
		FileManager.default.createFile(atPath: projectManifestUrl.path, contents: projectManifestData, attributes: nil)
		
		//
		// Write the archive manifest
		let archiveManifestData	= try encoder.encode(self.imdfArchive.manifest)
		let archiveManifestUrl	= ProjectManager.shared.url(forPathComponent: .archive(feature: .manifest), inProjectWithUuid: manifest.uuid)
		FileManager.default.createFile(atPath: archiveManifestUrl.path, contents: archiveManifestData, attributes: nil)
	}
	
	/// Deletes the project permanentely
	func delete() throws -> Void {
		try ProjectManager.shared.delete(withUuid: manifest.uuid)
	}
	
	/// Adds an extension to the IMDF archive
	///
	/// If the validation of the extension parts fails the function throws
	/// - Parameters:
	///   - provider: The extension provider name
	///   - name: The extension name
	///   - version: The extension version
	func addExtension(provider: String, name: String, version: String) throws -> Void {
		let extensionToAdd = try Extension.make(provider: provider, name: name, version: version)
		
		if self.imdfArchive.manifest.extensions == nil {
			self.imdfArchive.manifest.extensions = []
		}
		
		self.imdfArchive.manifest.extensions?.append(extensionToAdd)
	}
	
	/// Removes an extension from the project
	/// - Parameter extensionToRemove: The extension to remove
	func removeExtension(_ extensionToRemove: Extension) -> Void {
		self.imdfArchive.manifest.extensions?.removeAll(where: { (extensionInProject) -> Bool in
			return extensionToRemove.identifier == extensionInProject.identifier
		})
		
		if self.imdfArchive.manifest.extensions?.count ?? 0 == 0 {
			self.imdfArchive.manifest.extensions = nil
		}
	}
	
	/// Generates a UUID that is globally unique throughout all features in the IMDF data
	func getUnusedGlobalUuid() -> UUID {
		var usedUuids: [String] = []
		
		imdfArchive.addresses.forEach { usedUuids.append($0.id.uuidString) }
		imdfArchive.anchors.forEach { usedUuids.append($0.id.uuidString) }
		imdfArchive.venues.forEach { usedUuids.append($0.id.uuidString) }
		
		var unusedUuid: UUID
		repeat {
			unusedUuid = UUID()
		} while usedUuids.contains(unusedUuid.uuidString)
		
		return unusedUuid
	}
}
