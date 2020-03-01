//
//  Extension.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct Extension: Codable {
	
	enum ValidationError: Error {
		case invalidProvider
		case invalidName
		case invalidVersion
	}
	
	var provider: String
	var name: String
	var version: String
	
	var identifier: String {
		return "imdf:extension:\(provider):\(name)#\(version)"
	}
	
	private init(provider: String, name: String, version: String) {
		self.provider	= provider
		self.name		= name
		self.version	= version
	}
	
	/// Validates given extension parameters and returns an extension string if all are valid
	/// - Parameters:
	///   - provider: The extensions provider
	///   - name: The extensions name
	///   - version: The extensions version
	static func make(provider: String, name: String, version: String) throws -> Extension {
		if !isValidExtensionPart(provider) {
			throw ValidationError.invalidProvider
		}
		
		if !isValidExtensionPart(name) {
			throw ValidationError.invalidName
		}
		
		if !isValidExtensionPart(version) {
			throw ValidationError.invalidVersion
		}
		
		return Extension(provider: provider, name: name, version: version)
	}
	
	static func make(fromIdentifier identifier: String) -> Extension? {
		let parts = identifier.split(separator: ":")
		if parts.count != 4 {
			return nil
		}
		
		let nameVersionPart = parts[3].split(separator: "#")
		if nameVersionPart.count != 2 {
			return nil
		}
		
		let provider	= String(parts[2])
		let name		= String(nameVersionPart[0])
		let version		= String(nameVersionPart[1])
		
		return try? Extension.make(provider: provider, name: name, version: version)
	}
	
	private static func isValidExtensionPart(_ string: String) -> Bool {
		if string.count == 0 {
			return false
		}
		
		guard let firstCharacter = string.first, let lastCharacter = string.last else {
			return false
		}
		
		if !Extension.isCharacterAlphanumeric(firstCharacter) || !Extension.isCharacterAlphanumeric(lastCharacter) {
			return false
		}
		
		let start		= string.index(string.startIndex, offsetBy: 1)
		let end			= string.index(string.endIndex, offsetBy: -1)
		let range		= start..<end
		let midString	= String(string[range])
		
		var valid = true
		midString.forEach { (character) in
			if !Extension.isCharacterAlphanumeric(character) && character != "." && character != "-" && character != "_" {
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
}
