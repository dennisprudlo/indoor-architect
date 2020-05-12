//
//  FeatureAccessibilityPickerController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/12/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol FeatureAccessibilityPickerDelegate {
	func accessibilityPicker(_ pickerController: FeatureAccessibilityPickerController, didDismissWith accessibilities: [IMDFType.Accessibility]?) -> Void
}

class FeatureAccessibilityPickerController: IATableViewController {
	
	/// A mapping dictionary to store the accessibility value for each cell
	var accessibilityCells: [UITableViewCell: IMDFType.Accessibility] = [:]
	
	/// The currently selected accessibilities on initialization
	var currentAccessibilities: [IMDFType.Accessibility]?
	
	/// The delegate that handles the selection
	var delegate: FeatureAccessibilityPickerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.Feature.selectAccessibility
		
		//
		// In this case for better readability we use the separator line between the cells
		tableView.separatorStyle = .singleLine
		
		//
		// Compose the cells for the accessibilities
		IMDFType.Accessibility.allCases.forEach { (accessibility) in
			let accessibilityCell					= UITableViewCell(style: .default, reuseIdentifier: nil)
			accessibilityCell.textLabel?.text		= Localizable.IMDF.accessibility(accessibility)
			accessibilityCell.accessoryType			= currentAccessibilities?.contains(accessibility) ?? false ? .checkmark : .none
			accessibilityCell.tintColor				= Color.primary
			
			accessibilityCells[accessibilityCell]	= accessibility
		}
		
		//
		// Add the accessibility cells
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: accessibilityCells.sorted(by: { $0.value.rawValue < $1.value.rawValue }).map({ $0.key })
		))
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//
		// If the view controller is being dismissed (closed) we want to collect
		// all selected accessibilities and return them
		if isMovingFromParent {
			let selectedAccessibilities = accessibilityCells.filter({ $0.key.accessoryType == .checkmark }).map({ $0.value })
			delegate?.accessibilityPicker(self, didDismissWith: selectedAccessibilities.count > 0 ? selectedAccessibilities : nil)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		
		//
		// Toggle the current selection for the field
		tableView.deselectRow(at: indexPath, animated: true)
		cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
	}

}
