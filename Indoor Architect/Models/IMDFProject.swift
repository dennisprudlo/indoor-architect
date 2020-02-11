//
//  IMDFProject.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class IMDFProject {
	
	private let uuid: UUID
	
	var title: String?
	var description: String?
	var client: String?
	private var createdAt: Date = Date()
	private var updatedAt: Date = Date()
	
	init(uuid: UUID) {
		self.uuid	= uuid
		
		let createdAtDate = Date()
		self.createdAt = Date(timeIntervalSince1970: createdAtDate.timeIntervalSince1970)
		self.updatedAt = Date(timeIntervalSince1970: createdAtDate.timeIntervalSince1970)
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
		if !ProjectManager.shared.exists(withUuid: uuid) {
			try ProjectManager.shared.create(structurForProjectWithUuid: uuid)
		}
		
		let manifest: [String: String?] = [
			"uuid":				uuid.uuidString,
			"title":			title,
			"description":		description,
			"client":			client,
			"created_at":		DateUtils.iso8601(for: createdAt, withTime: true),
			"updated_at":		DateUtils.iso8601(for: updatedAt, withTime: true),
			"imdfproj_version":	"1"
		]
		
		let data = try JSONSerialization.data(withJSONObject: manifest, options: .prettyPrinted)
		FileManager.default.createFile(atPath: ProjectManager.shared.url(forPathComponent: .manifest, inProjectWithUuid: uuid).path, contents: data, attributes: nil)
	}
	
	/// Deletes the project permanentely
	func delete() throws -> Void {
		try ProjectManager.shared.delete(withUuid: uuid)
	}
	
	/// Updates the `updated_at` date in the projects manifest
	///
	/// This function is called everytime a change in the project has been made.
	func setUpdated() -> Void {
		self.updatedAt = Date()
	}
}
