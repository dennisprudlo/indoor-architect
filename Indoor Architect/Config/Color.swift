//
//  Color.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

enum Color {
	
	/// The primary tint color for the application
	static let primary: UIColor = .systemRed
	
	static let indoorMapEdit: UIColor = .systemIndigo
	
	static let indoorMapExport: UIColor = .systemGray2
	
	
	// MARK: Map Canvas
	
	static let rulerBaseColor: UIColor = UIColor.black
	
	static let currentDrawingTintColor: UIColor = Color.primary
	
	static let currentDrawingBorderColor: UIColor = UIColor.black.withAlphaComponent(0.8)
	
	static let anchorPointAnnotationTint: UIColor = .systemRed
	
	static let anchorPointAnnotationBorder: UIColor = .systemGray3
}
