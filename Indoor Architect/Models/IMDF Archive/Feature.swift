//
//  Feature.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

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
	
	var type: ProjectManager.ArchiveFeature
	
	enum CodingKeys: String, CodingKey {
		case id				= "id"
		case featureType	= "feature_type"
		case type			= "type"
		case properties		= "properties"
		case geometry		= "geometry"
	}
	
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
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode("\(type)", forKey: .featureType)
		
		let transformedGeometry: String? = nil
		try container.encode(transformedGeometry, forKey: .geometry)
		
		try container.encode("Feature", forKey: .type)
		try container.encode(properties, forKey: .properties)
	}
	
	init(withIdentifier identifier: UUID, properties: Properties, geometry: [MKShape & MKGeoJSONObject], type: ProjectManager.ArchiveFeature) {
		self.id			= identifier
		self.properties	= properties
		self.geometry	= geometry
		self.type		= type
		super.init()
	}
}
