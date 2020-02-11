//
//  IMDFProjectManifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class IMDFProjectManifest: Codable {
	
	let uuid: UUID
	var title: String
	var description: String?
	var client: String?
	let createdAt: Date
	var updatedAt: Date
	let imdfprojVersion: Int
	
	init(newWithUuid uuid: UUID, title: String) {
		self.uuid				= uuid
		self.title				= title
		self.description		= nil
		self.client				= nil
		self.createdAt			= Date()
		self.updatedAt			= Date()
		self.imdfprojVersion	= 1
	}
	
	func data() throws -> Data {
		return try JSONEncoder().encode(self)
	}
}
