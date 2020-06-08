//
//  MCDrawingConfirmToolStack.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/8/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class MCDrawingConfirmToolStack: MCToolStack {
	
	let confirmItem = MCDrawingConfirmToolStackItem(actionType: .confirm)
	let discardItem = MCDrawingConfirmToolStackItem(actionType: .discard)
	
	init() {
		super.init(forAxis: .vertical)
		
		addItem(confirmItem)
		addItem(discardItem)
		isHidden = true
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
