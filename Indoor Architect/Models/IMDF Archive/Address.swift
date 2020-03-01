//
//  Address.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class Address: Feature<Address.Properties> {
	
	struct Properties: Codable {
		let address: String
		let unit: String?
		let locality: String
		let provice: String
		let country: String
		let postalCode: String?
		let postalCodeExt: String?
		let postalCodeVanity: String?
	}
}
