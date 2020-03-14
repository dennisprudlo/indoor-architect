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
	
	var ruler: UIView
	
	var distance: CLLocationDistance {
		guard let start = startLocation, let end = endLocation else { return 0 }
		return MKMapPoint(start).distance(to: MKMapPoint(end))
	}
	
	init() {
		ruler = UIView()
		ruler.backgroundColor = .red
	}
	
	/// Makes the ruler using the given pan gesture recognizer
	/// - Parameter recognizer: The pan gesture recognizer while using it
	func makeUsingGesture(recognizer: UIPanGestureRecognizer) -> Void {
		let point = recognizer.location(in: canvas)
		let coordinate = canvas.convert(point, toCoordinateFrom: canvas)
		
		if recognizer.state == .began {
			startLocation	= coordinate
		}
		
		if recognizer.state == .ended {
			
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
		
		let dx = Double(endPoint.x - startPoint.x)
		let dy = Double(endPoint.y - startPoint.y)
		
		let rulerFrame = CGRect(origin: startPoint, size: CGSize(width: dx, height: dy))
		print("---")
		print(dx)
		print(dy)
		print("---")
		let theta = 90 - atan(dy == 0 ? 0 : dx / dy) * 180 / Double.pi
		print(theta)
		
		let angleInRadians = theta == 0 ? 0 : CGFloat(theta * Double.pi / 180)
		ruler.frame = rulerFrame
//		setRulerOrigin()
		ruler.transform = CGAffineTransform(rotationAngle: angleInRadians)
	}
	
	func setRulerOrigin() {
		let point = CGPoint(x: 0, y: 0)
		var newPoint = CGPoint(x: ruler.bounds.size.width * point.x, y: ruler.bounds.size.height * point.y)
		var oldPoint = CGPoint(x: ruler.bounds.size.width * ruler.layer.anchorPoint.x, y: ruler.bounds.size.height * ruler.layer.anchorPoint.y);
		
		newPoint = newPoint.applying(ruler.transform)
		oldPoint = oldPoint.applying(ruler.transform)
		
		var position = ruler.layer.position
		
		position.x -= oldPoint.x
		position.x += newPoint.x
		
		position.y -= oldPoint.y
		position.y += newPoint.y
		
		ruler.layer.position = position
		ruler.layer.anchorPoint = point
	}
	
	/// Holds the native map views gesture recognizers so the user can measure with a pan gesture
	func holdRecognizersForMeasuring() -> Void {
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
		
		ruler.frame = CGRect.zero
	}
}
