//
//  Manifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class Manifest {
	
	/// The version of the IMDF data format used in this project
	var version: String			= Application.imdfVersion
	
	/// The date the archive was created at
	var created: Date			= Date()
	
	/// The default language used for the project
	var language: String		= Application.localeLanguageTag
	
	/// The identifier of the mapping organization
	let generatedBy: String		= Application.versionIdentifier
	
	/// The list of extensions used in this project
	var extensions: [Extension]	= []
	
	/// Decodes the archive manifest from the project with the given UUID
	/// - Parameter uuid: The projects UUID
	static func decode(fromProjectWith uuid: UUID) throws -> Manifest {
		let manifestUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: .manifest), inProjectWithUuid: uuid)
		
		guard let contents = FileManager.default.contents(atPath: manifestUrl.path) else {
			throw IMDFDecodingError.corruptedFile
		}
		
		guard let object = try JSONSerialization.jsonObject(with: contents, options: .fragmentsAllowed) as? [String: Any] else {
			throw IMDFDecodingError.malformedManifest
		}
		
		//
		// Create a clean manifest
		let manifest = Manifest()
		
		//
		// Override the version
		if let version = object["version"] as? String {
			manifest.version = version
		}
		
		//
		// Override the created at date
		if let date = object["date"] as? String, let instance = DateUtils.instance(iso8601: date) {
			manifest.created = instance
		}
		
		//
		// Override the default language
		if let language	= object["language"] as? String {
			manifest.language = language
		}
		
		//
		// Add the extensions
		if let extensions = object["extensions"] as? [String] {
			extensions.forEach { (extensionIdentifier) in
				if let extensionToAdd = Extension.make(fromIdentifier: extensionIdentifier) {
					manifest.extensions.append(extensionToAdd)
				}
			}
		}
		
		return manifest
	}
	
	/// Encodes the IMDF manifest as JSON data
	func encode() throws -> Data {
		return try JSONSerialization.data(withJSONObject: [
			"version":		version,
			"created":		DateUtils.iso8601(for: created),
			"language":		language,
			"generated_by":	generatedBy,
			"extensions":	extensions.map({ (imdfExtension) -> String in
				return imdfExtension.identifier
			})
		], options: .prettyPrinted)
	}
}
