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
		
	let manifest: IMDFProjectManifest
	
	init(withUuid uuid: UUID, title: String) {
		self.manifest = IMDFProjectManifest(newWithUuid: uuid, title: title)
	}
	
	init(existingWith manifest: IMDFProjectManifest) {
		self.manifest = manifest
	}
	
	/// Gets a project by its `UUID`
	/// - Parameter uuid: the projects `UUID`
	static func find(_ uuid: UUID) -> IMDFProject? {
		return ProjectManager.shared.get(withUuid: uuid)
	}
	
	/// Gets all projects available for use
	static func all() -> [IMDFProject] {
		return ProjectManager.shared.getAll()
	}
	
	func save() throws -> Void {
		if !ProjectManager.shared.exists(withUuid: manifest.uuid) {
			try ProjectManager.shared.create(structurForProjectWithUuid: manifest.uuid)
		}
		
		let data = try manifest.data()
		FileManager.default.createFile(atPath: ProjectManager.shared.url(forPathComponent: .manifest, inProjectWithUuid: manifest.uuid).path, contents: data, attributes: nil)
	}
	
	/// Deletes the project permanentely
	func delete() throws -> Void {
		try ProjectManager.shared.delete(withUuid: manifest.uuid)
	}
	
	/// Updates the `updated_at` date in the projects manifest
	///
	/// This function is called everytime a change in the project has been made.
	func setUpdated() -> Void {
		manifest.updatedAt = Date()
	}
}
