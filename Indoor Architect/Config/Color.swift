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
	
	static let lightStyleTableViewBackground: UIColor = .systemBackground
	
	static let lightStyleCellSeparatorColor: UIColor = .clear
	
	static let lightStyleCellBackground = UIColor(named: "light-style-cell-background-color")
	
	
	// MARK: Map Canvas
	
	static let currentDrawingTintColor: UIColor = Color.primary
	
	static let currentDrawingBorderColor: UIColor = .black
	
	static let anchorPointAnnotationTint: UIColor = .systemRed
	
	static let anchorPointAnnotationBorder: UIColor = .systemGray3
}
