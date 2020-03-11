//
//  Anchor.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class Anchor: Feature<Anchor.Properties> {
	
	struct Properties: Codable {
		var addressId: UUID?
		var unitId: UUID?
	}
	
	func getCoordinates() -> CLLocationCoordinate2D {
		return geometry.first!.coordinate
	}
	
	func setCoordinates(_ coordinates: CLLocationCoordinate2D) -> Void {
		let point = MKPointAnnotation()
		point.coordinate = coordinates
		
		self.geometry = [point]
	}
}
