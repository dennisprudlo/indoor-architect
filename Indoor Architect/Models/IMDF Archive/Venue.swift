//
//  Venue.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Venue: Feature<Venue.Properties> {
	
	/// The venues properties
	struct Properties: Codable {
		/// The venues category. Use one of the predefined categories that fits the most
		var category:		IMDFType.VenueCategory = .businesscampus
		
		/// The venues restriction category
		var restriction:	IMDFType.Restriction?
		
		/// The venues name
		var name:			IMDFType.Labels?
		
		/// The venues alternative name. This can be used for internal names
		var altName:		IMDFType.Labels?
		
		/// The venues hours of operation. This must be a valid OSM Opening Hours string
		var hours:			IMDFType.Hours?
		
		/// The venues main phone number
		var phone:			IMDFType.Phone?
		
		/// The venues website address
		var website:		IMDFType.Website?
		
		/// The venues display point
		var displayPoint:	IMDFType.PointGeometry?
		
		/// Reference to an address entry for this venue
		var addressId:		IMDFType.FeatureID?
		
		/// A comment for the feature
		var information:	IMDFType.EntityInformation?
		
		func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(category,		forKey: .category)
			try container.encode(restriction,	forKey: .restriction)
			try container.encode(name,			forKey: .name)
			try container.encode(altName,		forKey: .altName)
			try container.encode(hours,			forKey: .hours)
			try container.encode(phone,			forKey: .phone)
			try container.encode(website,		forKey: .website)
			try container.encode(displayPoint,	forKey: .displayPoint)
			try container.encode(addressId,		forKey: .addressId)
			try container.encode(information,	forKey: .information)
		}
	}
	
	func set(comment: String?) -> Void {
		if properties.information == nil {
			properties.information = IMDFType.EntityInformation()
		}
		
		properties.information?.comment = comment
	}
}
