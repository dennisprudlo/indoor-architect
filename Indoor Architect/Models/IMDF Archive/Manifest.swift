//
//  Manifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class Manifest {
	
	var properties: Properties
	
	struct Properties: Codable {
		let version: String
		let created: String
		var language: String
		let generatedBy: String
		var extensions: [String]?
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
	
	/// Validates given extension parameters and returns an extension string if all are valid
	/// - Parameters:
	///   - provider: The extensions provider
	///   - name: The extensions name
	///   - version: The extensions version
	static func validateExtension(provider: String, name: String, version: String) -> String? {
		if isValidExtensionPart(provider) && isValidExtensionPart(name) && isValidExtensionPart(version) {
			return "imdf:extension:\(provider):\(name)#\(version)"
		}
		
		return nil
	}
	
	private static func isValidExtensionPart(_ string: String) -> Bool {
		if string.count == 0 {
			return false
		}
		
		guard let firstCharacter = string.first, let lastCharacter = string.last else {
			return false
		}
		
		if !isCharacterAlphanumeric(firstCharacter) || !isCharacterAlphanumeric(lastCharacter) {
			return false
		}
		
		let start		= string.index(string.startIndex, offsetBy: 1)
		let end			= string.index(string.endIndex, offsetBy: -1)
		let range		= start..<end
		let midString	= String(string[range])
		
		var valid = true
		midString.forEach { (character) in
			if !isCharacterAlphanumeric(character) && character != "." && character != "-" && character != "_" {
				valid = false
			}
		}
		
		return valid
	}
	
	private static func isCharacterAlphanumeric(_ character: Character) -> Bool {
		var valid = true
		character.unicodeScalars.forEach { (scalar) in
			if !CharacterSet.alphanumerics.contains(scalar) {
				valid = false
			}
		}
		
		return valid
	}
	
	func data() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(self.properties)
	}
}
