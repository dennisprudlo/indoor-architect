//
//  MCOverlayRenderer.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreGraphics
import MapKit

protocol MCOverlayRenderer {
	var isCurrentlyDrawing: Bool { get set }
	func markEndpoint(_ point: CGPoint, for zoomScale: MKZoomScale, in context: CGContext) -> Void
	func getPoints(of path: CGPath) -> [CGPoint]
}

extension MCOverlayRenderer {
	
	func markEndpoint(_ point: CGPoint, for zoomScale: MKZoomScale, in context: CGContext) -> Void {
		let radius: CGFloat = (1 / zoomScale) * 8
		context.addArc(center: point, radius: radius, startAngle: .pi * 2, endAngle: 0, clockwise: true)
		context.setStrokeColor(Color.currentDrawingBorderColor.cgColor)
		context.setLineWidth(1 / zoomScale)
		context.setFillColor(Color.currentDrawingTintColor.cgColor)
		context.drawPath(using: .fillStroke)
	}
	
	func getPoints(of path: CGPath) -> [CGPoint] {
		var points: [CGPoint] = []
		
		path.applyWithBlock { pathElement in
			let pointeePoints = pathElement.pointee.points
			switch pathElement.pointee.type {
				case .moveToPoint, .addLineToPoint:
					points.append(pointeePoints.pointee)
				case .addQuadCurveToPoint:
					points.append(pointeePoints.pointee)
					points.append(pointeePoints.advanced(by: 1).pointee)
				case .addCurveToPoint:
					points.append(pointeePoints.pointee)
					points.append(pointeePoints.advanced(by: 1).pointee)
					points.append(pointeePoints.advanced(by: 2).pointee)
				default:
					break
			}
		}
		
		return points
	}
}
