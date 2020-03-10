//
//  IMDFProjectManifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class IMDFProjectManifest: Codable {
	
	/// The UUID of the project
	let uuid: UUID
	
	/// The title of the project
	var title: String
	
	/// The optional description of the project
	var description: String?
	
	/// The optional client of the project
	var client: String?
	
	/// The date the project was created at
	let createdAt: Date
	
	/// The date the project was last updated at
	var updatedAt: Date
	
	/// The IMDFPROJ-data version used for migration to future versions
	let imdfprojVersion: Int
	
	/// Initializes a new project manifest
	/// - Parameters:
	///   - uuid: The uuid of the project
	///   - title: The title of the project
	init(newWithUuid uuid: UUID, title: String) {
		self.uuid				= uuid
		self.title				= title
		self.description		= nil
		self.client				= nil
		self.createdAt			= Date()
		self.updatedAt			= Date()
		self.imdfprojVersion	= 1
	}
	
	/// Encodes the manifest as JSON data
	func data() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(self)
	}
}
