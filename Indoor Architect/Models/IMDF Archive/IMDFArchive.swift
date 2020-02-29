//
//  IMDFArchive.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

enum IMDFDecodingError: Error {
	case malformedManifest
}

class IMDFArchive {
	
	let manifest: Manifest
	
	init(fromUuid uuid: UUID) throws {
		self.manifest = try Manifest.decode(fromProjectWith: uuid)
	}
	
}
