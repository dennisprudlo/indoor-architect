//
//  Anchor.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class Anchor: Feature<Anchor.Properties> {
	
	struct Properties: Codable {
		var addressId: UUID?
		var unitId: UUID?
	}
}
