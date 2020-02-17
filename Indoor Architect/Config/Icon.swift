//
//  Icon.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

enum Icon {
	
	static let apple	= UIImage(systemName: "folder.fill")!
	static let download	= UIImage(systemName: "arrow.down.doc.fill")!
	static let trash	= UIImage(systemName: "trash.fill")!
	static let map		= UIImage(systemName: "map.fill")!
	static let link		= UIImage(systemName: "link")!
	static let help		= UIImage(systemName: "questionmark.circle")!
	
	static let toolClose	= UIImage(systemName: "xmark")!
	
	static let drawingToolPointer = UIImage(systemName: "hand.draw")!
	static let drawingToolPolyline = UIImage(systemName: "italic")!
	static let drawingToolPolygon = UIImage(systemName: "skew")!
	static let drawingToolMeasure = UIImage(systemName: "perspective")!
	
	static func imageFor(drawingTool: MCMapCanvas.DrawingTool) -> UIImage {
		switch drawingTool {
			case .pointer:	return Icon.drawingToolPointer
			case .polyline:	return Icon.drawingToolPolyline
			case .polygon:	return Icon.drawingToolPolygon
			case .measure:	return Icon.drawingToolMeasure
		}
	}
}
