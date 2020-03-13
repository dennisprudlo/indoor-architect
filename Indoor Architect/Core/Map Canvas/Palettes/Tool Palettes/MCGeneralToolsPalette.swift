//
//  MCGeneralToolsPalette.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class MCGeneralToolsPalette: MCToolPalette {
	
	/// A reference to the close tool stack
	let closeToolStack = MCCloseToolStack(forAxis: .horizontal)
	
	/// A reference to the coordinate tool stack
	let coordinateToolStack	= MCCoordinateToolStack()
	
	init() {
		super.init(axis: .horizontal)
		
		closeToolStack.palette = self
		coordinateToolStack.palette = self
		
		addToolStack(closeToolStack)
		addToolStack(coordinateToolStack)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
