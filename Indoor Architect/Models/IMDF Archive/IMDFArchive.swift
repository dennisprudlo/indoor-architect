//
//  IMDFArchive.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

/// Defines the error cases for decoding IMDF data
enum IMDFDecodingError: Error {
	case corruptedFile
	case malformedManifest
	case malformedFeatureData
}

class IMDFArchive {
	
	let projectUuid: UUID
	
	/// The IMDF archives manifest
	let manifest: Manifest
	
	/// The IMDF address features
	var addresses: [Address]
	
	/// The IMDF venue features
	var venues: [Venue]
	
	/// The IMDF anchor features
	var anchors: [Anchor]
	
	/// Initializes the IMDFArchive
	/// - Parameter uuid: The UUID of the project
	init(fromUuid uuid: UUID) throws {
		self.projectUuid	= uuid
		
		let manifestUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: .manifest), inProjectWithUuid: uuid)
		guard let contents = FileManager.default.contents(atPath: manifestUrl.path) else {
			throw IMDFDecodingError.corruptedFile
		}
		
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		self.manifest		= try decoder.decode(Manifest.self, from: contents)
		
		self.addresses		= try IMDFArchive.decode(Address.self, file: .address, forProjectWithUuid: uuid)
		self.venues			= try IMDFArchive.decode(Venue.self, file: .venue, forProjectWithUuid: uuid)
		self.anchors		= try IMDFArchive.decode(Anchor.self, file: .anchor, forProjectWithUuid: uuid)
		
		//
		// Create anchor references
		anchors.forEach { (anchor) in
			// Link address
			if let addressId = anchor.properties.addressId?.uuidString, let address = addresses.first(where: { $0.id.uuidString == addressId }) {
				anchor.address = address
			}
			
			// Link unit
		}
	}
	
	/// Decodes the features from the corresponding GeoJSON file in a project with the given UUID
	/// - Parameters:
	///   - type: The Feature type
	///   - file: The file case where the GeoJSON is located
	///   - uuid: The UUID of the project
	static func decode<T: CodableFeature>(_ type: T.Type, file: ProjectManager.ArchiveFeature, forProjectWithUuid uuid: UUID) throws -> [T] {
		
		let fileUrl		= ProjectManager.shared.url(forPathComponent: .archive(feature: file), inProjectWithUuid: uuid)
		let fileData	= try Data(contentsOf: fileUrl)
		
		let geoJSONData	= try MKGeoJSONDecoder().decode(fileData)
		guard let features = geoJSONData as? [MKGeoJSONFeature] else {
			throw IMDFDecodingError.malformedFeatureData
		}
		
		return features.compactMap { try? type.init(feature: $0, type: file) }
	}
	
	/// Encodes the features of a given type and writes it into the corresponding GeoJSON file
	/// - Parameters:
	///   - features: The array of features to encode
	///   - propertiesType: The type of the features properties
	///   - file: The file case to write the data into
	///   - uuid: The UUID of the project
	func enocde<T: Feature<Properties>, Properties: Codable>(_ features: [T], of propertiesType: Properties.Type, in file: ProjectManager.ArchiveFeature) throws -> Void {
		
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
		
		let fileUrl = ProjectManager.shared.url(forPathComponent: .archive(feature: file), inProjectWithUuid: self.projectUuid)
		FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
	}
	
	func save(_ type: ProjectManager.ArchiveFeature) throws -> Void {
		switch type {
			case .address:
				try self.enocde(self.addresses, of: Address.Properties.self, in: .address)
			case .anchor:
				try self.enocde(self.anchors, of: Anchor.Properties.self, in: .anchor)
			case .venue:
				try self.enocde(self.venues, of: Venue.Properties.self, in: .venue)
			default:
				break
		}
	}
	
	/// Generates a UUID that is globally unique throughout all features in the IMDF data
	func getUnusedGlobalUuid() -> UUID {
		var usedUuids: [String] = []
		
		addresses.forEach { usedUuids.append($0.id.uuidString) }
		
		var unusedUuid: UUID
		repeat {
			unusedUuid = UUID()
		} while usedUuids.contains(unusedUuid.uuidString)
		
		return unusedUuid
	}
	
	func removeReferences(_ uuid: UUID) -> Void {
		anchors.forEach { (anchor) in
			if let addressId = anchor.properties.addressId, addressId.uuidString == uuid.uuidString {
				anchor.properties.addressId = nil
			}
		}
	}
	
	func delete(_ address: Address) -> Void {
		removeReferences(address.id)
		addresses.removeAll(where: { $0.id.uuidString == address.id.uuidString })
	}
	
	func delete(_ anchor: Anchor) -> Void {
		removeReferences(anchor.id)
		anchors.removeAll(where: { $0.id.uuidString == anchor.id.uuidString })
	}
}
