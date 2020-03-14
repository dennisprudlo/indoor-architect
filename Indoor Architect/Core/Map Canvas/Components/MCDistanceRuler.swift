//
//  MCDistanceRuler.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/14/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class MCDistanceRuler {
	
	var canvas: MCMapCanvas!
	
	var startLocation: CLLocationCoordinate2D?
	
	var endLocation: CLLocationCoordinate2D?
	
	var distance: CLLocationDistance {
		guard let start = startLocation, let end = endLocation else { return 0 }
		return MKMapPoint(start).distance(to: MKMapPoint(end))
	}
	
	func makeUsingGesture(recognizer: UIPanGestureRecognizer) -> Void {
		let point = recognizer.location(in: canvas)
		let coordinate = canvas.convert(point, toCoordinateFrom: canvas)
		
		if recognizer.state == .began {
			startLocation	= coordinate
			endLocation		= nil
		} else if recognizer.state == .ended {
			endLocation		= coordinate
			
			guard let start = startLocation, let end = endLocation else {
				startLocation	= nil
				endLocation		= nil
				return
			}
			
			presentRuler(from: MKMapPoint(start), to: MKMapPoint(end))
		}
	}
	
	func presentRuler(from start: MKMapPoint, to end: MKMapPoint) -> Void {
		let distance							= NSNumber(value: start.distance(to: end))
		let numberFormatter						= NumberFormatter()
		numberFormatter.numberStyle				= .decimal
		numberFormatter.maximumFractionDigits	= 2
		canvas.infoToolStack.display(text: "\(numberFormatter.string(from: distance) ?? "0") m", withLabel: "Distance", remain: 5)
	}
	
	func holdRecognizersForMeasuring() -> Void {
		guard let gestureRecognizers = canvas.subviews.first?.gestureRecognizers else {
			return
		}
		
		let compact = gestureRecognizers.compactMap({ $0 as? UIPanGestureRecognizer})
		compact.forEach { (panGestureRecognizer) in
			panGestureRecognizer.isEnabled = false
		}
	}
	
	func releaseRecognizersForMeasuring() -> Void {
		guard let gestureRecognizers = canvas.subviews.first?.gestureRecognizers else {
			return
		}
		
		let compact = gestureRecognizers.compactMap({ $0 as? UIPanGestureRecognizer})
		compact.forEach { (panGestureRecognizer) in
			panGestureRecognizer.isEnabled = true
		}
	}
	
	func invalidate() -> Void {
		startLocation	= nil
		endLocation		= nil
	}
}
