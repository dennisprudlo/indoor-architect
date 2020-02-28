//
//  GJFeatureCollection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class GJFeatureCollection {
	
	static let unassignedEntities = GJFeatureCollection()
	
	var features: [GJFeature]
	
	var featuresString: String {
		return features.map { (feature) -> String in
			return feature.geoJsonString()
		}.joined(separator: ",")
	}
	
	init() {
		features = []
	}
	
	func data() -> Data? {		
		return """
		{
			"type": "FeatureCollection",
			"features": [\(featuresString)]
		}
		""".data(using: .utf8)
	}
}
