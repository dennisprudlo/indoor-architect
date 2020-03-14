//
//  Mathematics.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/14/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreGraphics

class Mathematics {
	
	/// Converts an angle in degrees to radians
	/// - Parameter degrees: The angle in degrees
	func radians(from degrees: Double) -> Double {
		return degrees * Double.pi / 180
	}
	
	/// Converts an angle in radians to degrees
	/// - Parameter radians: The angle in radians
	func degrees(from radians: Double) -> Double {
		return radians / Double.pi * 180
	}
	
	/// Creates a vector from the given points
	/// - Parameters:
	///   - point: The point where the vector is pointing at
	///   - target: The origin of the vector
	func vector(from point: CGPoint, origin: CGPoint = CGPoint(x: 0, y: 0)) -> CGVector {
		return CGVector(dx: point.x - origin.x, dy: point.y - origin.y)
	}
}
