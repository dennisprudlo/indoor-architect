//
//  IMDFVenueOverlay.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/8/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class IMDFVenueOverlay: MKPolygon {
	
	var venue: Venue!
	
	static func from(venue: Venue) -> IMDFVenueOverlay? {
		guard let polygon = venue.geometry.first as? MKPolygon else {
			return nil
		}
		
		let overlay = IMDFVenueOverlay(points: polygon.points(), count: polygon.pointCount)
		overlay.venue = venue
		
		return overlay
	}
}
