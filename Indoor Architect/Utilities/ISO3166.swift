//
//  ISO3166.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 4/27/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class ISO3166 {
	
	/// A combination of an ISO 3166 code and a corresponding title to identify a locality
	typealias CodeCombination = (code: String, title: String)
	
	
	/// Gets the code combination for a given country code
	/// - Parameter countryCode: The country code to get the code combination for
	/// - Returns: The retrieved code combination
	static func getCountryData(for countryCode: String) -> CodeCombination? {
		let countryIdentifier	= NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: countryCode])
		if let countryName		= NSLocale(localeIdentifier: Locale.current.identifier).displayName(forKey: NSLocale.Key.identifier, value: countryIdentifier) {
			return CodeCombination(code: countryCode, title: countryName)
		}
		
		return nil
	}
	
	/// Gets a list of all available country code combinations
	/// - Returns: A list of all available combinations
	static func getCountryData() -> [CodeCombination] {
		return Locale.isoRegionCodes.map { (isoCountryCode) -> CodeCombination in
			if let countryData = self.getCountryData(for: isoCountryCode) {
				return countryData
			}
			
			return (code: isoCountryCode, title: Localizable.General.none)
		}.sorted { (firstCountry, secondCountry) -> Bool in
			return firstCountry.title < secondCountry.title
		}
	}
	
	/// Gets a list of all available subdivisions combinations for a given country code
	///
	/// If the country has no subdivisions or the passed country code is unknown the function returns an array
	/// with only one item containing the country code as passed and a localized title indicating there is no information
	/// - Parameter countryCode: The country code of the country where the subdivisions should be returned
	/// - Returns: A list of code combinations for all subdivisions in the given country
	static func getSubdivisionData(for countryCode: String) -> [CodeCombination] {
		guard let propertyListPath = Bundle.main.path(forResource: "ISO-3166-2", ofType: "plist") else {
			return []
		}
		
		guard let propertyList = NSDictionary(contentsOfFile: propertyListPath) as? Dictionary<String, Dictionary<String, String>> else {
			return []
		}
		
		guard let subdivisionCodes = propertyList[countryCode] else {
			return []
		}
		
		var combinations = subdivisionCodes.map { (entry) -> CodeCombination in
			return CodeCombination(title: entry.value, code: entry.key)
		}
		
		//
		// If the country is not divided into subdivisions we use the country identifier as a subdivision
		if combinations.count == 0 {
			if let countryData = ISO3166.getCountryData(for: countryCode) {
				return [countryData]
			}
			
			return [CodeCombination(code: countryCode, title: Localizable.General.none)]
		}
		
		combinations.sort { (firstSubdivision, secondSubdivision) -> Bool in
			return firstSubdivision.title < secondSubdivision.title
		}
		
		return combinations
	}
}
