//
//  FontUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

extension UIFont {
	
	/// Returns a`UIFont` instance with the given trait
	/// - Parameter traits: The trait to apply
	func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(traits)
		return UIFont(descriptor: descriptor!, size: 0)
	}
	
	/// Returns a `UIFont` with applied bold trait.
	func bold() -> UIFont {
		return withTraits(traits: .traitBold)
	}
	
	/// Returns a `UIFont` with applied monospace trait
	func monospaced() -> UIFont {
		return withTraits(traits: .traitMonoSpace)
	}
}
