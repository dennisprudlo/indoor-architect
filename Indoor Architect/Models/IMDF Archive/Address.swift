//
//  Address.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class Address: Feature<Address.Properties> {
	
	/// The adresses properties
	struct Properties: Codable {
		/// The prominent title of the address. This can be either a street name or a point of interest such as "Empire State Building"
		let address: String
		
		/// The optional unit. If this value is set the address is supposed to mark a qualified unit in the data and not a building or a venue
		let unit: String?
		
		/// The locality is the name of the city
		let locality: String
		
		/// The province has to be a valid ISO 3166-2 country subdivision code such as "US-CA" for California
		let province: String
		
		/// The country has to be a valid ISO 3166 country code such as "US" for the United States
		let country: String
		
		/// The postal code
		let postalCode: String?
		
		/// The extension of the postal code
		let postalCodeExt: String?
		
		/// The vanity of the postal code
		let postalCodeVanity: String?
	}
}