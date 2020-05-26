//
//  ButtonTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

	let cellButton = UIButton(type: .system)
	
	init(title: String) {
		super.init(style: .default, reuseIdentifier: nil)
		
		contentView.addSubview(cellButton)
		cellButton.translatesAutoresizingMaskIntoConstraints = false
		cellButton.setTitle(title, for: .normal)
		cellButton.setTitleColor(.white, for: .normal)
		cellButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).bold()
		cellButton.backgroundColor = Color.primary
		cellButton.setTitleColor(.systemGray3, for: .disabled)
		
		cellButton.topAnchor.constraint(equalTo:		topAnchor).isActive = true
		cellButton.trailingAnchor.constraint(equalTo:	trailingAnchor).isActive = true
		cellButton.bottomAnchor.constraint(equalTo:		bottomAnchor).isActive = true
		cellButton.leadingAnchor.constraint(equalTo:	leadingAnchor).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setEnabled(_ enabled: Bool, animated: Bool = false) -> Void {
		if animated {
			UIView.animate(withDuration: 0.2) {
				self.cellButton.backgroundColor = enabled ? Color.primary : .systemGray5
				self.cellButton.isEnabled = enabled
			}
		} else {
			self.cellButton.backgroundColor = enabled ? Color.primary : .systemGray5
			self.cellButton.isEnabled = enabled
		}
	}
}
