//
//  IMDFVenueOverlay.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class IMDFVenueOverlay: MKPolygon {
	
	var venue: Venue
	
	init(venue: Venue) {
		self.venue = venue
	}
	
}
