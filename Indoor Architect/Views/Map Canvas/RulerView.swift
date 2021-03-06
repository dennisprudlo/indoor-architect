//
//  RulerView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/14/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class RulerView: UIView {
	
	private let rulerHeightUpperBound: Double = 90
	private let rulerHeightLowerBound: Double = 50
	
	typealias Edges = (origin: CGPoint, target: CGPoint, lowerOrigin: CGPoint, lowerTarget: CGPoint)
	
	var edges: Edges?
	
	init() {
		super.init(frame: CGRect.zero)
		backgroundColor = .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		guard let drawingContext = UIGraphicsGetCurrentContext() else {
			return
		}
		
		if let edges = edges {
			drawRulerPath(context: drawingContext, edges)
		}
	}
	
	func drawRulerPath(context: CGContext, _ edges: Edges) -> Void {
		
		let path = CGMutablePath()
		path.move(to: edges.origin)
		path.addLine(to: edges.target)
		path.addLine(to: edges.lowerTarget)
		path.addLine(to: edges.lowerOrigin)
		path.closeSubpath()
		
		context.setStrokeColor(Color.rulerBaseColor.withAlphaComponent(0.7).cgColor)
		context.setFillColor(Color.rulerBaseColor.withAlphaComponent(0.4).cgColor)
		context.setLineWidth(1)
		
		context.addPath(path)
		context.fillPath()
		
		context.addPath(path)
		context.strokePath()
	}
	
	func transform(from start: CGPoint, to end: CGPoint) -> Void {
		
		var rightToLeft: CGFloat = start.x > end.x ? -1 : 1
		if end.y < start.y {
			rightToLeft *= -1
		}
		
		let dx = Double(end.x - start.x)
		let dy = Double(end.y - start.y)
		
		//
		// Calculate the ruler length to determine the height
		let rulerLength			= sqrt(dx * dx + dy + dy)
		let appliedRulerHeight	= Double.maximum(rulerHeightLowerBound, Double.minimum(rulerHeightUpperBound, rulerLength * 0.1))
		
		let thetaFirst = dy == 0 ? 0 : Double.pi - (Double.pi / 2) - atan(dx / dy)
		let thetaSecond = Double.pi - (Double.pi / 2) - thetaFirst
		let thetaThird = Double.pi - (Double.pi / 2) - thetaSecond
		
		let offsetX = CGFloat(sin(thetaThird) * appliedRulerHeight) * rightToLeft
		let offsetY = CGFloat(cos(thetaThird) * appliedRulerHeight) * rightToLeft
		
		let lowerOrigin = CGPoint(x: start.x - offsetX, y: start.y + offsetY)
		let lowerTarget = CGPoint(x: end.x - offsetX, y: end.y + offsetY)
		edges = Edges(origin: start, target: end, lowerOrigin: lowerOrigin, lowerTarget: lowerTarget)
		
		setNeedsDisplay()
	}
}
