//
//  FontUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

extension UIFont {
	
	func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(traits)
		return UIFont(descriptor: descriptor!, size: 0)
	}
	
	func bold() -> UIFont {
		return withTraits(traits: .traitBold)
	}
}
