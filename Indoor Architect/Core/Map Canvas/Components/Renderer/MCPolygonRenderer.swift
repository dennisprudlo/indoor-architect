//
//  MCPolygonRenderer.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class MCPolygonRenderer: MKPolygonRenderer {
	
	var isCurrentlyDrawing: Bool = false
	
	init(overlay: MKOverlay, _ isCurrentlyDrawing: Bool) {
		super.init(polygon: overlay as! MKPolygon)
		
		self.isCurrentlyDrawing = isCurrentlyDrawing
		
		if isCurrentlyDrawing {
			strokeColor	= Color.currentDrawingFeatureColor
			fillColor	= Color.currentDrawingFeatureColor.withAlphaComponent(0.3)
			lineWidth	= 2
		} else {
			strokeColor	= UIColor.systemGray
			fillColor	= UIColor.systemGray.withAlphaComponent(0.3)
			lineWidth	= 2
		}
	}
	
	override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
		var points: [CGPoint] = []
		path.applyWithBlock { element in
			if element.pointee.type == .moveToPoint || element.pointee.type == .addLineToPoint {
				points.append(element.pointee.points.pointee)
			}
		}
		
		if let last = points.last {
			print("last")
			print(last)
			let radius: CGFloat = 10
			context.addArc(center: last, radius: radius, startAngle: 0, endAngle: 180, clockwise: true)
			context.setStrokeColor(Color.currentDrawingFeatureColor.cgColor)
			context.setLineWidth(2)
			context.setFillColor(Color.currentDrawingFeatureColor.withAlphaComponent(0.3).cgColor)
			context.fillPath()
			print("filled path")
		}
		
		super.draw(mapRect, zoomScale: zoomScale, in: context)
	}
	
	override func createPath() {
		let path = CGMutablePath()
		
		var firstPoint: CGPoint?
		
		for index in 0..<polygon.pointCount {
			let point = self.point(for: polygon.points()[index])
			if path.isEmpty {
				firstPoint = point
				path.move(to: point)
			} else {
				path.addLine(to: point)
			}
		}
		
		if !isCurrentlyDrawing, let firstPoint = firstPoint {
			path.addLine(to: firstPoint)
		}
		
		self.path = path
	}
}
