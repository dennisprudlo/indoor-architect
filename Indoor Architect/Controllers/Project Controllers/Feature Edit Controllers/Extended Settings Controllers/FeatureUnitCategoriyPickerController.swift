//
//  FeatureUnitCategoriyPickerController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/12/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol FeatureUnitCategoryPickerDelegate {
	func unitCategoryPicker(_ pickerController: FeatureUnitCategoryPickerController, didPick category: IMDFType.UnitCategory) -> Void
}

class FeatureUnitCategoryPickerController: IATableViewController {

	var categoryCells: [UITableViewCell: IMDFType.UnitCategory] = [:]
	
	var currentCategory: IMDFType.UnitCategory = .unspecified
	
	var delegate: FeatureUnitCategoryPickerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = Localizable.Feature.selectCategory
		
		tableView.separatorStyle = .singleLine
		
		IMDFType.UnitCategory.allCases.forEach { (category) in
			let categoryCell = UITableViewCell(style: .default, reuseIdentifier: nil)
			categoryCell.textLabel?.text	= Localizable.IMDF.unitCategory(category)
			categoryCell.accessoryType		= category == currentCategory ? .checkmark : .none
			categoryCell.tintColor			= Color.primary
			
			categoryCells[categoryCell] = category
		}
		
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: categoryCells.sorted(by: { $0.value.rawValue < $1.value.rawValue }).map({ $0.key })
		))
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath), let category = categoryCells[cell] else {
			delegate?.unitCategoryPicker(self, didPick: .unspecified)
			return
		}
	
		delegate?.unitCategoryPicker(self, didPick: category)
	}
}
