//
//  Manifest.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class Manifest: Codable {
	
	/// The version of the IMDF data format used in this project
	var version: String			= Application.imdfVersion
	
	/// The date the archive was created at
	var created: Date			= Date()
	
	/// The default language used for the project
	var language: String		= Application.localeLanguageTag
	
	/// The identifier of the mapping organization
	let generatedBy: String		= Application.versionIdentifier
	
	/// The list of extensions used in this project
	var extensions: [Extension]?
	
	enum CodingKeys: String, CodingKey {
		case version
		case created
		case language
		case generatedBy
		case extensions
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(version,		forKey: .version)
		try container.encode(created,		forKey: .created)
		try container.encode(language,		forKey: .language)
		try container.encode(generatedBy,	forKey: .generatedBy)
		try container.encode(extensions,	forKey: .extensions)
	}
	
	init() {
		// Empty initializer uses the default values
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		version		= try container.decode(String.self, forKey: .version)
		created		= try container.decode(Date.self, forKey: .created)
		language	= try container.decode(String.self, forKey: .language)
		extensions	= try container.decode([Extension]?.self, forKey: .extensions)
	}
}
