//
//  SwitchTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

	let cellSwitch = UISwitch()
	
	init() {
		super.init(style: .default, reuseIdentifier: nil)
		
		selectionStyle	= .none
		
		self.accessoryView = cellSwitch
		cellSwitch.onTintColor = Color.primary
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
