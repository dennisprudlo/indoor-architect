//
//  TableViewUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

extension UITableViewCell {
	
	/// Creates a table view cell with the given style and the given titles
	/// This is function is helpful for creating fixed/static table view cells
	/// - Parameters:
	///   - title: The primary title
	///   - detail: The detail title
	///   - style: The table view cell
	/// - Returns: The generated table view cell
	static func fixed(title: String?, detail: String?, style: UITableViewCell.CellStyle = .value1) -> UITableViewCell {
		let cell = UITableViewCell(style: style, reuseIdentifier: nil)
		cell.textLabel?.text		= title
		cell.detailTextLabel?.text	= detail
		cell.tintColor				= Color.primary
		cell.selectionStyle			= .none
		
		return cell
	}
	
}
