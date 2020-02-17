//
//  ImageTextButton.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ImageTextButton: UIButton {

	static func make(title: String, color: UIColor, image: UIImage?, customTintColor: UIColor = .white, spacing: CGFloat = 20) -> UIButton {
		let button = UIButton(type: .system)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font		= UIFont.preferredFont(forTextStyle: .headline).bold()
		button.tintColor			= customTintColor
		button.backgroundColor		= color
		button.layer.cornerRadius	= Style.cornerRadius
		button.imageEdgeInsets		= UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
		button.titleEdgeInsets		= UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: 0)
		
		button.setTitle(title, for: .normal)
		button.setTitleColor(customTintColor, for: .normal)
		button.setImage(image, for: .normal)
		
		return button
	}
}
