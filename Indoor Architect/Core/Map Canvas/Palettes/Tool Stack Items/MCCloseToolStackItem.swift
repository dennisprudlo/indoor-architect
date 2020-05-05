//
//  MCCloseToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCCloseToolStackItem: MCToolStackItem, MCToolStackItemDelegate {
	
	var canvas: MCMapCanvas?
	
	init(_ canvas: MCMapCanvas, isDefault: Bool = false) {
		super.init(isDefault: isDefault)
		super.delegate = self
		
		self.canvas = canvas
		
		imageView.image				= Icon.toolClose
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
		canvas?.saveAndClose()
	}
}
