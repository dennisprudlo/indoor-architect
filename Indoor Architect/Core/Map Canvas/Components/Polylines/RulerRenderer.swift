//
//  FlexiblePolylineRenderer.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/14/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class RulerRenderer: MKPolylineRenderer {
	
	override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
		context.saveGState()
		
		if polyline.pointCount == 1 {
			
		} else {
		
			//
			// Render the ruler border
			strokeColor	= UIColor.systemGray
			lineWidth	= 1
			lineCap		= .butt
			applyStrokeProperties(to: context, atZoomScale: zoomScale)
			strokePath(rulerBorderPath(), in: context)
			
		
			//
			// Render the ruler background
//			strokeColor	= UIColor.systemGray2
//			lineWidth	= 10
//			lineCap		= .butt
//			applyStrokeProperties(to: context, atZoomScale: zoomScale)
//			strokePath(rulerFrame(), in: context)
		}

		context.restoreGState()
	}
	
	func rulerBorderPath() -> CGMutablePath! {
		guard polyline.pointCount > 1 else {
			return nil
		}
		
		let begin	= polyline.points()[0]
		let end		= polyline.points()[1]
		
		let path = CGMutablePath()
		path.move(to: point(for: begin))
		path.addLine(to: point(for: end))
		
		let vector = CGVector(dx: end.x - begin.x, dy: end.y - begin.y)
		let rotated = rotate(vector: vector, by: 90)
		
		//
		// Create lower end point
		let newEnd = MKMapPoint(x: end.x + Double(rotated.dx), y: end.y + Double(rotated.dy))
		
		print("----")
		print(rotated)
		print(begin)
		print(end)
		print(newEnd)
		print("----")
		
		path.addLine(to: point(for: newEnd))
		path.closeSubpath()
		
		return path
	}
	
	private func rotate(vector: CGVector, by degrees: Double) -> CGVector {

		// The current angle of the vector
		let theta = atan(Double(vector.dy) / Double(vector.dx)) * 180 / Double.pi
		
		// The new angle for the output vector
		let angle = (theta + degrees) + 180
		
		// Transform the angle to radians
		let angleRadians = angle * Double.pi / 180
		
		// Determine the new delta x and delta y value for the vector
		let dx = cos(angleRadians) * 10000
		let dy = sin(angleRadians) * 10000
		
		return CGVector(dx: dx, dy: dy)
	}
}
