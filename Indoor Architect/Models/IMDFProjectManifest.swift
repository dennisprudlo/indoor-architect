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
	
	/// The meta data information for the mapping session of that project
	var session: MappingSession?
	
	struct MappingSession: Codable {
		/// The latitude of the last position
		var centerLatitude: Double
		/// The longitude of the last position
		var centerLongitude: Double
		/// The latitude span of the last position
		var spanLatitude: Double
		/// The longitude span of the last position
		var spanLongitude: Double
	}
	
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
		self.session			= nil
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(uuid,				forKey: .uuid)
		try container.encode(title,				forKey: .title)
		
		let descriptionToEncode = description?.count ?? 0 == 0 ? nil : description
		try container.encode(descriptionToEncode, forKey: .description)
		
		let clientToEncode = client?.count ?? 0 == 0 ? nil : client
		try container.encode(clientToEncode,	forKey: .client)
		
		try container.encode(createdAt,			forKey: .createdAt)
		try container.encode(updatedAt,			forKey: .updatedAt)
		try container.encode(session,			forKey: .session)
		try container.encode(imdfprojVersion,	forKey: .imdfprojVersion)
	}
}
