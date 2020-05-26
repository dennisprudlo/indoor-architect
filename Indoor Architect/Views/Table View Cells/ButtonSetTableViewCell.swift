//
//  ButtonSetTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ButtonSetTableViewCell: UITableViewCell {

	private let buttonStackView = UIStackView()
	
	var spacing: CGFloat = 16 {
		didSet {
			buttonStackView.spacing = self.spacing
		}
	}
	
	init(buttons: [UIButton]) {
		super.init(style: .default, reuseIdentifier: nil)
		
		backgroundColor = .clear
		
		contentView.addSubview(buttonStackView)
		buttonStackView.autolayout()
		buttonStackView.axis = .horizontal
		buttonStackView.spacing = self.spacing
		buttonStackView.alignment = .fill
		buttonStackView.distribution = .fillEqually
		NSLayoutConstraint.activate([
			buttonStackView.topAnchor.constraint(equalTo: topAnchor),
			buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
		])
		
		addButtons(buttons)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addButton(_ button: UIButton) -> Void {
		button.layer.cornerRadius = 10
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).bold()
		buttonStackView.addArrangedSubview(button)
	}
	
	func addButtons(_ buttons: [UIButton]) -> Void {
		buttons.forEach { (button) in
			addButton(button)
		}
	}
}
