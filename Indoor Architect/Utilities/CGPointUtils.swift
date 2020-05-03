//
//  CGPointUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
	
	func distance(to point: CGPoint) -> CGFloat {
		let dx = point.x - self.x
		let dy = point.y - self.y
		return sqrt(dx * dx + dy * dy)
	}
	
}
