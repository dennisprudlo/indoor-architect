//
//  TextInputTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class TextInputTableViewCell: UITableViewCell {

	private let viewInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
	
	let textField = UITextField()
	
	init(placeholder: String) {
		super.init(style: .default, reuseIdentifier: nil)
		
		selectionStyle = .none
		tintColor = Color.primary
		
		contentView.addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = placeholder
		
		textField.topAnchor.constraint(equalTo:			topAnchor,		constant: viewInset.top).isActive = true
		textField.trailingAnchor.constraint(equalTo:	trailingAnchor,	constant: -viewInset.right).isActive = true
		textField.bottomAnchor.constraint(equalTo:		bottomAnchor,	constant: -viewInset.bottom).isActive = true
		textField.leadingAnchor.constraint(equalTo:		leadingAnchor,	constant: viewInset.left).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
