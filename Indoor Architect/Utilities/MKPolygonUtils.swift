//
//  MKPolygonUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

extension MKPolygon {
	
	/// Checks whether a given coordinate is inside a polygon
	/// - Parameter coordinate: the coordinate
	/// - Returns: true if the coordinate is inside the polygon
	func contains(coordinate: CLLocationCoordinate2D) -> Bool {
		let renderer = MKPolygonRenderer(polygon: self)
		
		guard let rendererPath = renderer.path else {
			return false
		}
		
		let point = renderer.point(for: MKMapPoint(coordinate))
		return rendererPath.contains(point)
	}
	
	/// An array of all coordinates used to compose the polygon
	var coordinates: [CLLocationCoordinate2D] {
		var coordinates = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
		getCoordinates(&coordinates, range: NSRange(location: 0, length: pointCount))
		return coordinates
	}
}
