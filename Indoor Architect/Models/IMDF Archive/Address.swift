//
//  Address.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class Address: Feature<Address.Properties> {
	
	typealias LocalityCodeCombination = (code: String, title: String)
	
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
	
	static func getLocalizedCountryCodes() -> [Address.LocalityCodeCombination] {
		var combinations: [Address.LocalityCodeCombination] = []
		
		Locale.isoRegionCodes.forEach { (isoCountryCode) in
			let countryIdentifier	= NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: isoCountryCode])
			if let countryName			= NSLocale(localeIdentifier: Locale.current.identifier).displayName(forKey: NSLocale.Key.identifier, value: countryIdentifier) {
				combinations.append(Address.LocalityCodeCombination(code: isoCountryCode, title: countryName))
			}
		}
		
		combinations.sort { (first, second) -> Bool in
			return first.title < second.title
		}
		
		return combinations
	}
	
	static func getSubdivisions(forCountry countryCode: String) -> [Address.LocalityCodeCombination] {
		guard let propertyListPath = Bundle.main.path(forResource: "ISO-3166-2", ofType: "plist") else {
			return []
		}
		
		guard let propertyList = NSDictionary(contentsOfFile: propertyListPath) as? Dictionary<String, Dictionary<String, String>> else {
			return []
		}
		
		guard let subdivisionCodes = propertyList[countryCode] else {
			return []
		}
		
		var combinations = subdivisionCodes.map { (entry) -> Address.LocalityCodeCombination in
			return Address.LocalityCodeCombination(title: entry.value, code: entry.key)
		}
		
		combinations.sort { (first, second) -> Bool in
			return first.title < second.title
		}
		
		return combinations
	}
}
