//
//  GJFeature.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class GJFeature {
	
	let type: GJFeature.FeatureType
	
	enum FeatureType: String {
		case point = "Point"
		case lineString = "LineString"
		case polygon = "Polygon"
	}
	
	init(type: GJFeature.FeatureType) {
		self.type = type
	}
	
	func geoJsonString() -> String {
		return """
		{
			"type": "Feature",
			"properties": {},
			"geometry": null
		}
		"""
	}
}
