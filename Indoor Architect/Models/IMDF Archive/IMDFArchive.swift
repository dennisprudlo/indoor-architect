//
//  IMDFArchive.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

enum IMDFDecodingError: Error {
	case corruptedFile
	case malformedManifest
	case malformedFeatureData
}

class IMDFArchive {
	
	let manifest: Manifest
	
	let addresses: [Address]
	
	init(fromUuid uuid: UUID) throws {
		self.manifest = try Manifest.decode(fromProjectWith: uuid)
		
		self.addresses = try IMDFArchive.decodeFeature(Address.self, file: .address, forProjectWithUuid: uuid)
	}
	
	static func decodeFeature<T: DecodableFeature>(_ type: T.Type, file: ProjectManager.ArchiveFeature, forProjectWithUuid uuid: UUID) throws -> [T] {
		
		let fileUrl		= ProjectManager.shared.url(forPathComponent: .archive(feature: file), inProjectWithUuid: uuid)
		let fileData	= try Data(contentsOf: fileUrl)
		
		let geoJSONData	= try MKGeoJSONDecoder().decode(fileData)
		guard let features = geoJSONData as? [MKGeoJSONFeature] else {
			throw IMDFDecodingError.malformedFeatureData
		}
		
		return try features.map { try type.init(feature: $0) }
	}
}
