//
//  GJPointFeature.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreLocation

class GJPointFeature: GJFeature {
	
	var coordinates: CLLocationCoordinate2D
	
	init(coordinates: CLLocationCoordinate2D) {
		self.coordinates = coordinates
		
		super.init(type: .point)
	}
	
	override func geoJsonString() -> String {
		return """
		{
			"type": "Feature",
			"properties": {},
			"geometry": {
				"type": "\(type.rawValue)",
				"coordinates": [\(coordinates.latitude), \(coordinates.longitude)]
			}
		}
		"""
	}
}
