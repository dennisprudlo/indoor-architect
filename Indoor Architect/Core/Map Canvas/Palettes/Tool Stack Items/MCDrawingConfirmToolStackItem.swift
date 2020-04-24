//
//  MCDrawingConfirmToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCDrawingConfirmToolStackItem: MCToolStackItem, MCToolStackItemDelegate {
	
	private var actionType: ActionType = .confirm
	
	enum ActionType {
		case confirm
		case discard
	}
	
	init(actionType: ActionType) {
		super.init(isDefault: false)
		super.delegate = self
		
		self.actionType				= actionType
		
		imageView.image				= actionType == .confirm ? Icon.toolConfirmShape : Icon.toolClose
		preventIndicatingSelection	= true
		
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: MCToolStackItem.toolStackItemSize),
			heightAnchor.constraint(equalTo: widthAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func toolStackItem(_ toolStackItem: MCToolStackItem, registeredTapFrom tapGestureRecognizer: UITapGestureRecognizer) {
		guard let canvas = stack?.canvas else {
			return
		}
		
		guard let assembler = canvas.getActiveShapeAssembler() else {
			canvas.hideConfirmShapeButton()
			return
		}
		
		//
		// If the action type is the discard button we want to discard the overlay
		if actionType == .discard {
			assembler.removeActiveOverlay()
			canvas.discardActiveShapeAssembler()
			return
		}
		
		//
		// Retrieve the geometry from the current overlay
		let geometry = assembler.collect()
		
		//
		// Add the feature to the canvas
		switch assembler {
			case is MCPolygonAssembler:
				canvas.addVenue(geometry)
			default:
				break
		}
		
		//
		// Clean-up the shape assembler
		assembler.removeActiveOverlay()
		canvas.discardActiveShapeAssembler()
	}
	
}
