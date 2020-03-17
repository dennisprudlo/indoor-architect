//
//  MCPolygonAssembler.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class MCPolygonAssembler: MCShapeAssembler {
	
	override func add(_ coordinate: CLLocationCoordinate2D) -> Void {
		super.add(coordinate)
		
		let overlay: MKOverlay
		if coordinates.count == 2 {
			overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
		} else {
			overlay = collect().first as! MKPolygon
		}
		
		renderActiveOverlay(overlay: overlay)
	}
	
	override func collect() -> [MKShape & MKGeoJSONObject] {
		return [MKPolygon(coordinates: coordinates, count: coordinates.count)]
	}
	
}
