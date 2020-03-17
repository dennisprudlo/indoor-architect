//
//  Extension.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct Extension: Codable {
	
	/// Defines the error cases for validating the extension parts
	enum ValidationError: Error {
		case invalidProvider
		case invalidName
		case invalidVersion
	}
	
	/// The extension provider name
	var provider: String
	
	/// The extension name
	var name: String
	
	/// The extension version
	var version: String
	
	/// The composed identifier of the extension
	var identifier: String {
		return "imdf:extension:\(provider):\(name)#\(version)"
	}
	
	/// Initialize an extension with the given parts
	///
	/// The initializer is private because it creates an extension without validating the parts.
	/// To create an extension outside of this class use the static `make`-method.
	/// - Parameters:
	///   - provider: The extension provider name
	///   - name: The extension name
	///   - version: The extension version
	private init(provider: String, name: String, version: String) {
		self.provider	= provider
		self.name		= name
		self.version	= version
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let identifier = try container.decode(String.self)
		
		let parts = identifier.split(separator: ":")
		
		//
		// We expect exactly four colon-separated parts
		if parts.count != 4 {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "The identifier must have four colon-separatable parts.")
		}
		
		//
		// The last part must contain hash which is used to split the name and the version of the extension
		let nameVersionPart = parts[3].split(separator: "#")
		if nameVersionPart.count != 2 {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "The last colon separated part must have two hash-separatable parts.")
		}
		
		//
		// Retrieve the raw string parts for the identifier
		let provider	= String(parts[2])
		let name		= String(nameVersionPart[0])
		let version		= String(nameVersionPart[1])
		
		if !Extension.isValidExtensionPart(provider) {
			throw ValidationError.invalidProvider
		}
		
		if !Extension.isValidExtensionPart(name) {
			throw ValidationError.invalidName
		}
		
		if !Extension.isValidExtensionPart(version) {
			throw ValidationError.invalidVersion
		}
		
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
		
		//
		// Create an extension with the given parts
		return Extension(provider: provider, name: name, version: version)
	}
	
	/// Check whether the given string is a valid extension part string
	/// - Parameter string: The string to validate
	private static func isValidExtensionPart(_ string: String) -> Bool {
		
		//
		// An extenstion part must be at least 1 character long
		if string.count == 0 {
			return false
		}
		
		//
		// Retrieve the first and last character
		guard let firstCharacter = string.first, let lastCharacter = string.last else {
			return false
		}
		
		//
		// If the first or the last character is not alphanumeric, the extension part is not valid
		if !Extension.isCharacterAlphanumeric(firstCharacter) || !Extension.isCharacterAlphanumeric(lastCharacter) {
			return false
		}
		
		//
		// Check if the string contains only valid characters
		var valid = true
		string.forEach { (character) in
			if !Extension.isCharacterValidMidString(character) {
				valid = false
			}
		}
		
		return valid
	}
	
	/// Check whether the given character is an alphanumeric characters
	/// - Parameter character: The character to validate
	private static func isCharacterAlphanumeric(_ character: Character) -> Bool {
		var valid = true
		character.unicodeScalars.forEach { (scalar) in
			if !CharacterSet.alphanumerics.contains(scalar) {
				valid = false
			}
		}
		
		return valid
	}
	
	/// Check if the given character is a valid character for an extension part
	/// - Parameter character: The character to validate
	private static func isCharacterValidMidString(_ character: Character) -> Bool {
		return Extension.isCharacterAlphanumeric(character) || character == "." || character == "-" || character == "_"
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(identifier)
	}
}
