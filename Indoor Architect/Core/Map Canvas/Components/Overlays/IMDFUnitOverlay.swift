//
//  IMDFUnitOverlay.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class IMDFUnitOverlay: MKPolygon {
	
	var unit: Unit!
	
	static func from(unit: Unit) -> IMDFUnitOverlay? {
		guard let polygon = unit.geometry.first as? MKPolygon else {
			return nil
		}
		
		let overlay = IMDFUnitOverlay(points: polygon.points(), count: polygon.pointCount)
		overlay.unit = unit
		
		return overlay
	}
}
