//
//  Feature.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

/// The `CodableFeature` protocol forces each feature to have an initializer using a `MKGeoJSONFeature` object and conform to the `Encodable` protocol
protocol CodableFeature: Encodable {
	init(feature: MKGeoJSONFeature, type: ProjectManager.ArchiveFeature) throws
}

class Feature<Properties: Codable>: NSObject, CodableFeature {
	
	/// The globally unique feature id identifier
	var id: UUID
	
	/// The features feature type
	var properties: Properties
	
	/// The geometry object of the feature
	var geometry: [MKShape & MKGeoJSONObject]
	
	/// The type of the feature
	var type: ProjectManager.ArchiveFeature
	
	/// The coding keys used by the encoder and decoder to associate properties
	enum CodingKeys: String, CodingKey {
		case id				= "id"
		case featureType	= "feature_type"
		case type			= "type"
		case properties		= "properties"
		case geometry		= "geometry"
	}
	
	/// Initializes the GeoJSON feature
	/// - Parameters:
	///   - feature: The GeoJSON feature data
	///   - type: The type of the feature
	required init(feature: MKGeoJSONFeature, type: ProjectManager.ArchiveFeature) throws {
		guard let uuidString = feature.identifier, let uuid = UUID(uuidString: uuidString) else {
			throw IMDFDecodingError.malformedFeatureData
		}
		
		self.id = uuid
		
		if let propertiesData = feature.properties {
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			self.properties = try decoder.decode(Properties.self, from: propertiesData)
		} else {
			throw IMDFDecodingError.malformedFeatureData
		}
		
		self.geometry = feature.geometry
		self.type = type
		
		super.init()
	}
	
	/// Encodes the GeoJSON feature
	/// - Parameter encoder: The encoder instance
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode("\(type)", forKey: .featureType)
		
		let transformedGeometry: String? = nil
		try container.encode(transformedGeometry, forKey: .geometry)
		
		try container.encode("Feature", forKey: .type)
		try container.encode(properties, forKey: .properties)
	}
	
	/// Initializes a GeoJSON feature by the manually given properties
	/// - Parameters:
	///   - identifier: The identifier UUID of the feature
	///   - properties: The features properties
	///   - geometry: The geometry data for the feature
	///   - type: The feature type
	init(withIdentifier identifier: UUID, properties: Properties, geometry: [MKShape & MKGeoJSONObject], type: ProjectManager.ArchiveFeature) {
		self.id			= identifier
		self.properties	= properties
		self.geometry	= geometry
		self.type		= type
		super.init()
	}
}
