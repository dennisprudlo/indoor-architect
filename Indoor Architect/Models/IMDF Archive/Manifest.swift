//
//  Manifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class Manifest {
	
	let properties: Properties
	
	struct Properties: Codable {
		let version: String
		let created: String
		let language: String
		let generatedBy: String
		let extensions: [String]?
	}

	init(properties: Properties) {
		self.properties = properties
	}
	
	init(version: String, created: String, language: String, generatedBy: String, extensions: [String]?) {
		self.properties = Properties(version: version, created: created, language: language, generatedBy: generatedBy, extensions: extensions)
	}
	
	static func decode(fromProjectWith uuid: UUID) throws -> Manifest {
		let manifestUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: .manifest), inProjectWithUuid: uuid)
		guard let contents = FileManager.default.contents(atPath: manifestUrl.path) else {
			throw IMDFDecodingError.malformedManifest
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let properties = try decoder.decode(Properties.self, from: contents)
		
		return Manifest(properties: properties)
	}
	
	func data() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(self.properties)
	}
}
