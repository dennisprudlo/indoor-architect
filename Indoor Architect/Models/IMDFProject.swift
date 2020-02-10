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
	
	var title: String
	var description: String?
	var client: String?
	private var createdAt: Date = Date()
	private var updatedAt: Date = Date()
	
	init(uuid: UUID, title: String) {
		self.uuid	= uuid
		self.title	= title
		
		let createdAtDate = Date()
		self.createdAt = Date(timeIntervalSince1970: createdAtDate.timeIntervalSince1970)
		self.updatedAt = Date(timeIntervalSince1970: createdAtDate.timeIntervalSince1970)
	}
	
	static func unusedUuid() -> UUID {
		var unusedUuid: UUID
		repeat {
			unusedUuid = UUID()
		} while ProjectManager.shared.exists(withUuid: unusedUuid)
		
		return unusedUuid
	}
	
	static func find(_ uuid: UUID) -> IMDFProject {
		return IMDFProject(uuid: UUID(), title: "Title")
	}
	
	static func all() -> [IMDFProject] {
		return []
	}
	
	func save() throws -> Void {
		if !ProjectManager.shared.exists(withUuid: uuid) {
			try ProjectManager.shared.create(structurForProjectWithUuid: uuid)
		}
		
		let data = try JSONSerialization.data(withJSONObject: [
			"uuid":				uuid.uuidString,
			"title":			title,
			"description":		description,
			"client":			client,
			"created_at":		DateUtils.iso8601(for: createdAt, withTime: true),
			"updated_at":		DateUtils.iso8601(for: updatedAt, withTime: true),
			"imdfproj_version":	1
		], options: .prettyPrinted)
		FileManager.default.createFile(atPath: ProjectManager.shared.url(forPathComponent: .manifest, inProjectWithUuid: uuid).path, contents: data, attributes: nil)
	}
	
	func delete() throws -> Void {
		try ProjectManager.shared.delete(withUuid: uuid)
	}
	
	func setUpdated() -> Void {
		self.updatedAt = Date()
	}
}
