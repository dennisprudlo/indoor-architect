//
//  MCDrawingToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCDrawingToolStackItem: MCToolStackItem, MCToolStackItemDelegate {
	
	private var drawingTool: MCMapCanvas.DrawingTool = .pointer
	
	init(for drawingTool: MCMapCanvas.DrawingTool, isDefault: Bool = false) {
		super.init(isDefault: isDefault)
		super.delegate = self
		
		self.drawingTool = drawingTool
		
		switch drawingTool {
			case .pointer:	imageView.image = Icon.drawingToolPointer
			case .anchor:	imageView.image = Icon.drawingToolAnchor
			case .polyline:	imageView.image = Icon.drawingToolPolyline
			case .polygon:	imageView.image = Icon.drawingToolPolygon
			case .measure:	imageView.image = Icon.drawingToolMeasure
		}
		
		if isDefault {
			setSelected(true)
		}
		
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: MCToolStackItem.toolStackItemSize),
			heightAnchor.constraint(equalTo: widthAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func toolStackItem(_ toolStackItem: MCToolStackItem, registeredTapFrom tapGestureRecognizer: UITapGestureRecognizer) {
		stack?.canvas.switchDrawingTool(drawingTool)
	}
}
