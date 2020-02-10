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
	
	private var title: String
	private var description: String?
	private var client: String?
	private var createdAt: Date = Date()
	private var updatedAt: Date = Date()
	
	init(uuid: UUID, title: String) {
		self.uuid = uuid
		self.title = title
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
	}
	
	func delete() throws -> Void {
		try ProjectManager.shared.delete(withUuid: uuid)
	}
}
