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
	
	/// The anchors properties
	struct Properties: Codable {
		/// Reference to an address entry for this anchor
		var addressId:	IMDFType.FeatureID?
		
		/// Reference to a unit entry for this anchor
		var unitId:		IMDFType.FeatureID?
		
		func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(addressId,	forKey: .addressId)
			try container.encode(unitId,	forKey: .unitId)
		}
	}
	
	/// Gets the coordinates of the anchor
	func getCoordinates() -> CLLocationCoordinate2D {
		return geometry.first!.coordinate
	}
	
	/// Sets the coordinates of the anchor
	func setCoordinates(_ coordinates: CLLocationCoordinate2D) -> Void {
		let point = MKPointAnnotation()
		point.coordinate = coordinates
		
		self.geometry = [point]
	}
}
