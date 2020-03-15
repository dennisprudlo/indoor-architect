//
//  RulerView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/14/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class RulerView: UIView {
	
	private let rulerHeight: CGFloat = 50
	
	typealias Edges = (origin: CGPoint, target: CGPoint, lowerOrigin: CGPoint, lowerTarget: CGPoint)
	
	private var edges: Edges?
	
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
		context.move(to: edges.origin)
		context.addLine(to: edges.target)
		context.addLine(to: edges.lowerTarget)
		context.addLine(to: edges.lowerOrigin)
		context.closePath()
		
		context.setStrokeColor(UIColor.blue.cgColor)
		context.setLineWidth(5)
		context.strokePath()
		let size = CGSize(width: 5, height: 5)
		context.setFillColor(UIColor.green.cgColor)
		
		context.fill([
			CGRect(origin: edges.origin, size: size),
			CGRect(origin: edges.target, size: size)
		])
		
		context.setFillColor(UIColor.red.cgColor)
		
		context.fill([
			CGRect(origin: edges.lowerOrigin, size: size),
			CGRect(origin: edges.lowerTarget, size: size)
		])
	}
	
	func transform(from start: CGPoint, to end: CGPoint) -> Void {
		
		var rightToLeft: CGFloat = start.x > end.x ? -1 : 1
		if end.y < start.y {
			rightToLeft *= -1
		}
		
		let dx = Double(end.x - start.x)
		let dy = Double(end.y - start.y)
		
		let thetaFirst = dy == 0 ? 0 : Double.pi - (Double.pi / 2) - atan(dx / dy)
		let thetaSecond = Double.pi - (Double.pi / 2) - thetaFirst
		let thetaThird = Double.pi - (Double.pi / 2) - thetaSecond
		
		let offsetX = CGFloat(sin(thetaThird) * Double(rulerHeight)) * rightToLeft
		let offsetY = CGFloat(cos(thetaThird) * Double(rulerHeight)) * rightToLeft
		
		
		let lowerOrigin = CGPoint(x: start.x - offsetX, y: start.y + offsetY)
		let lowerTarget = CGPoint(x: end.x - offsetX, y: end.y + offsetY)
		edges = Edges(origin: start, target: end, lowerOrigin: lowerOrigin, lowerTarget: lowerTarget)
		
		setNeedsDisplay()
	}
}
