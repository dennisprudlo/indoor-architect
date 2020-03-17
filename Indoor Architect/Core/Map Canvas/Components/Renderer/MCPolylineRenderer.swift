//
//  MCPolylineRenderer.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class MCPolylineRenderer: MKPolylineRenderer, MCOverlayRenderer {
	
	var isCurrentlyDrawing: Bool = false
	
	init(overlay: MKOverlay, _ isCurrentlyDrawing: Bool) {
		super.init(polyline: overlay as! MKPolyline)
		
		self.isCurrentlyDrawing = isCurrentlyDrawing
		
		if isCurrentlyDrawing {
			strokeColor	= Color.currentDrawingTintColor
			lineWidth	= Renderer.featureLineWidth
		} else {
			strokeColor	= UIColor.systemGray
			lineWidth	= Renderer.featureLineWidth
		}
	}
	
	override init(overlay: MKOverlay) {
		//
		// Overriding this initializer is necessary otherwise the MKPolylineRenderer
		// won't find this overlay initializer
		super.init(overlay: overlay)
	}
	
	override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
		super.draw(mapRect, zoomScale: zoomScale, in: context)
		
		//
		// Only proceed if the overlay is a currently drawing overlay
		if !isCurrentlyDrawing {
			return
		}
		
		//
		// Retrieve the points of the path
		let points = getPoints(of: path)
		
		//
		// Add the point mark of the last point in the path
		if let last = points.last {
			markEndpoint(last, for: zoomScale, in: context)
		}
	}
	
	override func createPath() {
		let path = CGMutablePath()
	
		for index in 0..<polyline.pointCount {
			let point = self.point(for: polyline.points()[index])
			if path.isEmpty {
				path.move(to: point)
			} else {
				path.addLine(to: point)
			}
		}
		
		self.path = path
	}
}
