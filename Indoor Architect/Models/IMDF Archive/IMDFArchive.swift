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
	
	var addresses: [Address]
	
	init(fromUuid uuid: UUID) throws {
		self.manifest = try Manifest.decode(fromProjectWith: uuid)
		
		do {
			self.addresses = try IMDFArchive.decode(Address.self, file: .address, forProjectWithUuid: uuid)
		} catch {
			print(error)
			self.addresses = []
		}
	}
	
	static func decode<T: CodableFeature>(_ type: T.Type, file: ProjectManager.ArchiveFeature, forProjectWithUuid uuid: UUID) throws -> [T] {
		
		let fileUrl		= ProjectManager.shared.url(forPathComponent: .archive(feature: file), inProjectWithUuid: uuid)
		let fileData	= try Data(contentsOf: fileUrl)
		
		let geoJSONData	= try MKGeoJSONDecoder().decode(fileData)
		guard let features = geoJSONData as? [MKGeoJSONFeature] else {
			throw IMDFDecodingError.malformedFeatureData
		}
		
		return try features.map { try type.init(feature: $0, type: file) }
	}
	
	func enocde<T: Feature<Properties>, Properties: Codable>(_ features: [T], of propertiesType: Properties.Type, in file: ProjectManager.ArchiveFeature, forProjectWithUuid uuid: UUID) throws -> Void {
		
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy	= .convertToSnakeCase
		encoder.outputFormatting	= .prettyPrinted
		
		let encodedFeatures = try features.map { (feature) -> [String: Any] in
			let encodedFeature = try encoder.encode(feature)
			let serialized = try JSONSerialization.jsonObject(with: encodedFeature, options: .mutableContainers) as? [String: Any]
			return serialized ?? [:]
		}
		
		let data = try JSONSerialization.data(withJSONObject: [
			"name":		"\(file)",
			"type":		"FeatureCollection",
			"features":	encodedFeatures
		], options: .prettyPrinted)
		
		let fileUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: file), inProjectWithUuid: uuid)
		FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
	}
	
	func getUnusedGlobalUuid() -> UUID {
		var usedUuids: [String] = []
		
		addresses.forEach { usedUuids.append($0.id.uuidString) }
		
		var unusedUuid: UUID
		repeat {
			unusedUuid = UUID()
		} while usedUuids.contains(unusedUuid.uuidString)
		
		return unusedUuid
	}
}
