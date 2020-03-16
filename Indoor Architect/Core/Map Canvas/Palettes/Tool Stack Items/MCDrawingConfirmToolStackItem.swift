//
//  MCDrawingConfirmToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCDrawingConfirmToolStackItem: MCToolStackItem, MCToolStackItemDelegate {
	
	override init(isDefault: Bool = false) {
		super.init(isDefault: isDefault)
		super.delegate = self
		
		imageView.image = Icon.toolConfirmShape
		preventIndicatingSelection = true
		
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
		
		let geometry = assembler.collect()
		
		switch assembler {
			case is MCPolygonAssembler:
				canvas.addVenue(geometry)
			default:
				break
		}
		
		assembler.removeActiveOverlay()
		canvas.discardActiveShapeAssembler()
	}
	
}
