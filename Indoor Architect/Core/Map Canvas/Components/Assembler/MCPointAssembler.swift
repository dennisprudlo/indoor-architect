//
//  MCPointAssembler.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class MCPointAssembler: MCShapeAssembler {
	
	override func collect() -> [MKShape & MKGeoJSONObject] {
		guard let location = coordinates.first else {
			return []
		}
		
		let point = MKPointAnnotation()
		point.coordinate = location
		
		return [point]
	}

}
