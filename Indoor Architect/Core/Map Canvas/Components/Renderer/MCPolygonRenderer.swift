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
			strokeColor	= Color.currentDrawingTintColor
			fillColor	= Color.currentDrawingTintColor.withAlphaComponent(0.3)
			lineWidth	= Renderer.featureLineWidth
		} else {
			strokeColor	= UIColor.systemGray
			fillColor	= UIColor.systemGray.withAlphaComponent(0.3)
			lineWidth	= Renderer.featureLineWidth
		}
	}
	
	override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
		super.draw(mapRect, zoomScale: zoomScale, in: context)
		
		//
		// Only proceed if the overlay is a currently drawing overlay
		if !isCurrentlyDrawing {
			return
		}
		
		var points: [CGPoint] = []
		path.applyWithBlock { element in
			if element.pointee.type == .moveToPoint || element.pointee.type == .addLineToPoint {
				points.append(element.pointee.points.pointee)
			}
		}
		
		//
		// Add the point mark of the last point in the path
		if let last = points.last {
			let radius: CGFloat = (1 / zoomScale) * 8
			context.addArc(center: last, radius: radius, startAngle: .pi * 2, endAngle: 0, clockwise: true)
			context.setStrokeColor(Color.currentDrawingBorderColor.cgColor)
			context.setLineWidth(1 / zoomScale)
			context.setFillColor(Color.currentDrawingTintColor.cgColor)
			context.drawPath(using: .fillStroke)
		}
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
