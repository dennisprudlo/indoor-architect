//
//  Manifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class Manifest {
	
	var version: String			= Application.imdfVersion
	var created: Date			= Date()
	var language: String		= Application.localeLanguageTag
	var generatedBy: String?	= Application.versionIdentifier
	var extensions: [Extension]	= []
	
	static func decode(fromProjectWith uuid: UUID) throws -> Manifest {
		let manifestUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: .manifest), inProjectWithUuid: uuid)
		
		guard let contents = FileManager.default.contents(atPath: manifestUrl.path) else {
			throw IMDFDecodingError.corruptedFile
		}
		
		guard let object = try JSONSerialization.jsonObject(with: contents, options: .fragmentsAllowed) as? [String: Any] else {
			throw IMDFDecodingError.malformedManifest
		}
		
		let manifest = Manifest()
		
		if let version = object["version"] as? String {
			manifest.version = version
		}
		
		if let date = object["date"] as? String, let instance = DateUtils.instance(iso8601: date) {
			manifest.created = instance
		}
		
		if let language	= object["language"] as? String {
			manifest.language = language
		}
		
		manifest.generatedBy = object["generated_by"] as? String
		
		if let extensions = object["extensions"] as? [String] {
			extensions.forEach { (extensionIdentifier) in
				if let extensionToAdd = Extension.make(fromIdentifier: extensionIdentifier) {
					manifest.extensions.append(extensionToAdd)
				}
			}
		}
		
		return manifest
	}
	
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
