//
//  ImageTextButton.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ImageTextButton: UIButton {

	static func make(title: String, color: UIColor, image: UIImage?, customTintColor: UIColor = .white) -> UIButton {
		let button = UIButton(type: .system)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle(title, for: .normal)
		button.setTitleColor(customTintColor, for: .normal)
		button.setImage(image, for: .normal)
		button.tintColor = customTintColor
		button.backgroundColor = color
		button.layer.cornerRadius = 7.5
		
		return button
	}
}
