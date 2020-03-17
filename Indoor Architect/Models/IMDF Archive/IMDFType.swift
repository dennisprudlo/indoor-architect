//
//  IMDFType.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct IMDFType {
	
	struct PointGeometry: Codable {
		let type: String = "Point"
		let coordinates: [Double]
	}
	
	struct PolygonGeometry: Codable {
		let type: String = "Polygon"
		let coordinates: [[[Double]]]
	}
	
	typealias Labels = Dictionary<String, String>
	
	typealias FeatureID = UUID
	typealias Hours = String
	typealias Website = String
	typealias Phone = String
	
	enum Restriction: String, Codable {
		case employeesonly
		case restricted
	}
	
	enum VenueCategory: String, Codable {
		case airport
		case airportIntl = "airport.intl"
		case aquarium
		case businesscampus
		case casino
		case communitycenter
		case conventioncenter
		case governmentfacility
		case healthcarefacility
		case hotel
		case museum
		case parkingfacility
		case resort
		case retailstore
		case shoppingcenter
		case stadium
		case stripmall
		case theater
		case themepark
		case trainstation
		case transitstation
		case university
	}
	
}
