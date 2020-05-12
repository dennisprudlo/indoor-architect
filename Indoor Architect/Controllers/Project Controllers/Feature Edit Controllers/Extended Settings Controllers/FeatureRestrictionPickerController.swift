//
//  FeatureRestrictionPickerController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/12/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol FeatureRestrictionPickerDelegate {
	func restrictionPicker(_ pickerController: FeatureRestrictionPickerController, didDismissWith restriction: IMDFType.Restriction?) -> Void
}

class FeatureRestrictionPickerController: IATableViewController {

	/// A mapping dictionary to store the restriction value for each cell
	var restrictionCells: [UITableViewCell: IMDFType.Restriction] = [:]
	
	/// The currently selected restriction on initialization
	var currentRestriction: IMDFType.Restriction?
	
	/// The delegate that handles the selection
	var delegate: FeatureRestrictionPickerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.Feature.selectRestriction
		
		//
		// In this case for better readability we use the separator line between the cells
		tableView.separatorStyle = .singleLine
		
		//
		// Compose the cells for the categories
		IMDFType.Restriction.allCases.forEach { (restriction) in
			let restrictionCell					= UITableViewCell(style: .default, reuseIdentifier: nil)
			restrictionCell.textLabel?.text		= Localizable.IMDF.restriction(restriction)
			restrictionCell.accessoryType		= currentRestriction != nil && currentRestriction! == restriction ? .checkmark : .none
			restrictionCell.tintColor			= Color.primary
			
			restrictionCells[restrictionCell]	= restriction
		}
		
		//
		// Add the accessibility cells
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: restrictionCells.sorted(by: { $0.value.rawValue < $1.value.rawValue }).map({ $0.key })
		))
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//
		// If the view controller is being dismissed (closed) we want to collect
		// all selected accessibilities and return them
		if isMovingFromParent {
			let selectedRestriction = restrictionCells.first(where: { $0.key.accessoryType == .checkmark })?.value
			print(selectedRestriction)
			delegate?.restrictionPicker(self, didDismissWith: selectedRestriction)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		tableView.deselectRow(at: indexPath, animated: true)
		
		let newAccessoryType: UITableViewCell.AccessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
		
		//
		// Reset the accessory type for all cells
		restrictionCells.forEach({ $0.key.accessoryType = .none })
		
		//
		// Set the new accessory type for the selected cell
		cell.accessoryType = newAccessoryType
	}
}
