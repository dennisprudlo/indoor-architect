//
//  VenueEditCategoryController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/8/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol VenueEditCategoryControllerDelegate {
	func venueCateogry(_ controller: VenueEditCategoryController, didPick category: IMDFType.VenueCategory) -> Void
}

class VenueEditCategoryController: IATableViewController {
	
	/// A mapping dictionary to store the category value for each cell
	var categoryCells: [UITableViewCell: IMDFType.VenueCategory] = [:]
	
	/// The currently selected category on initialization
	var currentCategory: IMDFType.VenueCategory = .businesscampus
	
	/// The delegate that handles the selection
	var delegate: VenueEditCategoryControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.Feature.selectCategory
		
		//
		// In this case for better readability we use the separator line between the cells
		tableView.separatorStyle = .singleLine
		
		//
		// Compose the cells for the categories
		IMDFType.VenueCategory.allCases.forEach { (category) in
			let categoryCell = UITableViewCell(style: .default, reuseIdentifier: nil)
			categoryCell.textLabel?.text	= "\(category)"//Localizable.IMDF.unitCategory(category)
			categoryCell.accessoryType		= category == currentCategory ? .checkmark : .none
			categoryCell.tintColor			= Color.primary
			
			categoryCells[categoryCell] = category
		}
		
		//
		// Add the accessibility cells
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: categoryCells.sorted(by: { $0.value.rawValue < $1.value.rawValue }).map({ $0.key })
		))
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath), let category = categoryCells[cell] else {
			delegate?.venueCateogry(self, didPick: self.currentCategory	)
			return
		}
		
		delegate?.venueCateogry(self, didPick: category)
	}
}
