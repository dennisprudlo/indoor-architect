//
//  MCShapeAssembler.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MCShapeAssembler {
	
	var coordinates: [CLLocationCoordinate2D] = []
	
	func add(_ coordinate: CLLocationCoordinate2D) -> Void {
		coordinates.append(coordinate)
	}
	
	func collect() -> [MKShape & MKGeoJSONObject] {
		return []
	}
}
