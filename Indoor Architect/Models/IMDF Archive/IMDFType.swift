//
//  IMDFType.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct IMDFType {
	
	typealias Labels = Dictionary<String, String>
	
	typealias Hours = String
	
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
