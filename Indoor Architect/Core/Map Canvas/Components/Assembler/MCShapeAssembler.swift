//
//  MCShapeAssembler.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MCShapeAssembler {
	
	var canvas: MCMapCanvas
	
	var activeOverlay: MKOverlay?
	
	var coordinates: [CLLocationCoordinate2D] = []
	
	init(in canvas: MCMapCanvas) {
		self.canvas = canvas
	}
	
	func add(_ coordinate: CLLocationCoordinate2D) -> Void {
		coordinates.append(coordinate)
	}
	
	func collect() -> [MKShape & MKGeoJSONObject] {
		return []
	}
	
	func renderActiveOverlay(overlay: MKOverlay) -> Void {
		removeActiveOverlay()
		
		activeOverlay = overlay
		canvas.addOverlay(overlay)
	}
	
	func removeActiveOverlay() -> Void {
		if let activeOverlay = activeOverlay {
			canvas.removeOverlay(activeOverlay)
		}
	}
}
