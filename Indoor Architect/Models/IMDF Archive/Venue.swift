//
//  Venue.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreLocation

class Venue: Feature<Venue.Properties> {
	
	struct Properties: Codable {
		var category: IMDFType.VenueCategory = .businesscampus
		var restriction: IMDFType.Restriction?
		var name: IMDFType.Labels?
		var altName: IMDFType.Labels?
		var hours: String?
		var phone: String?
		var website: String?
//		var displayPoint: String?
		var addressId: UUID?
	}
}
