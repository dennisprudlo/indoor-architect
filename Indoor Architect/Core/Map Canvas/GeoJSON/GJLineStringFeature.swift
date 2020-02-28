//
//  GJLineStringFeature.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreLocation

class GJLineStringFeature: GJFeature {
	
	var coordinates: [CLLocationCoordinate2D]
	
	var coordinatesString: String {
		return coordinates.map { (coordinates) -> String in
			return "[\(coordinates.latitude), \(coordinates.longitude)]"
		}.joined(separator: ",")
	}
	
	init(coordinates: [CLLocationCoordinate2D]) {
		self.coordinates = coordinates
		
		super.init(type: .lineString)
	}
	
	override func geoJsonString() -> String {
		return """
		{
			"type": "Feature",
			"properties": {},
			"geometry": {
				"type": "\(type.rawValue)",
				"coordinates": [\(coordinatesString)]
			}
		}
		"""
	}
}
