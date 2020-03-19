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
	
	var canvas: MCMapCanvas! {
		willSet {
			ruler.removeFromSuperview()
		}
		didSet {
			canvas.addSubview(ruler)
		}
	}
	
	var startLocation: CLLocationCoordinate2D?
	
	var endLocation: CLLocationCoordinate2D?
	
	var ruler = RulerView()
	
	var distance: CLLocationDistance {
		guard let start = startLocation, let end = endLocation else { return 0 }
		return MKMapPoint(start).distance(to: MKMapPoint(end))
	}
	
	/// Makes the ruler using the given pan gesture recognizer
	/// - Parameter recognizer: The pan gesture recognizer while using it
	func makeUsingGesture(recognizer: InitialPanGestureRecognizer) -> Void {
		let point = recognizer.location(in: canvas)
		let coordinate = canvas.convert(point, toCoordinateFrom: canvas)
		
		if recognizer.state == .began {
			let initialPoint: CGPoint	= recognizer.getInitialPoint()
			let startCoordinate			= canvas.convert(initialPoint, toCoordinateFrom: canvas)
			startLocation				= startCoordinate
		}
		
		endLocation		= coordinate
		
		guard let start = startLocation, let end = endLocation else {
			startLocation	= nil
			endLocation		= nil
			return
		}
		
		drawRuler(from: MKMapPoint(start), to: MKMapPoint(end))
	}
	
	/// Presents the ruler on the canvas
	/// - Parameters:
	///   - start: The rulers start point
	///   - end: The rulers end point
	func drawRuler(from start: MKMapPoint, to end: MKMapPoint) -> Void {
		let distance							= NSNumber(value: start.distance(to: end))
		let numberFormatter						= NumberFormatter()
		numberFormatter.numberStyle				= .decimal
		numberFormatter.maximumFractionDigits	= 2
		canvas.infoToolStack.display(text: "\(numberFormatter.string(from: distance) ?? "0") m", withLabel: "Distance", remain: 5)
		
		let startPoint = canvas.convert(start.coordinate, toPointTo: canvas)
		let endPoint = canvas.convert(end.coordinate, toPointTo: canvas)
		
		ruler.transform(from: startPoint, to: endPoint)
	}
	
	/// Holds the native map views gesture recognizers so the user can measure with a pan gesture
	func holdRecognizersForMeasuring() -> Void {
		canvas.panGestureRecognizer.isEnabled = true
		ruler.frame = canvas.frame
		
		guard let gestureRecognizers = canvas.subviews.first?.gestureRecognizers else {
			return
		}
		
		let compact = gestureRecognizers.compactMap({ $0 as? UIPanGestureRecognizer})
		compact.forEach { (panGestureRecognizer) in
			panGestureRecognizer.isEnabled = false
		}
	}
	
	/// Releases the native map views gesture recognizers so the user can use the pan gesture to move around
	func releaseRecognizersForMeasuring() -> Void {
		canvas.panGestureRecognizer.isEnabled = false
		ruler.frame = CGRect.zero
		
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
		ruler.edges		= nil
		ruler.frame		= CGRect.zero
		
		ruler.setNeedsDisplay()
	}
}
