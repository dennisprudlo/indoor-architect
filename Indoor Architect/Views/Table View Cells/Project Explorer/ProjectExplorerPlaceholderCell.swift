//
//  ProjectExplorerPlaceholderCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/15/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerPlaceholderCell: UITableViewCell {
	
	init(title: String) {
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle				= .none
		isUserInteractionEnabled	= false

		textLabel?.text				= title
		textLabel?.numberOfLines	= 0
		textLabel?.textColor		= .secondaryLabel
		backgroundColor				= .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
