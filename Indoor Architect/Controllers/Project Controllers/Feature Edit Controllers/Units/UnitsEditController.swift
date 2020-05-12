//
//  UnitsEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class UnitsEditController: PolygonalFeatureEditController, FeatureEditControllerDelegate {

	/// A reference to the unit that is being edited
	var unit: Unit!
	
	/// The cell that allows to edit the units category
	var categoryCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the units restriction type
	var restrictionCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the units accessibility type
	var accessibilityCell	= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
    override func viewDidLoad() {
		super.viewDidLoad()
		super.prepareForFeature(with: unit.id, information: unit.properties.information, from: self)
		
		//
		// Prepare PolygonFeatureEditController
		setGeometryEdges(count: unit.getCoordinates().count)
	
		title = "Edit Unit"
		
		//
		// Format the category, restriction and accessibility cells
		categoryCell.textLabel?.text		= Localizable.Feature.selectCategory
		restrictionCell.textLabel?.text		= Localizable.Feature.selectRestriction
		accessibilityCell.textLabel?.text	= Localizable.Feature.selectAccessibility
		
		categoryCell.accessoryType			= .disclosureIndicator
		restrictionCell.accessoryType		= .disclosureIndicator
		accessibilityCell.accessoryType		= .disclosureIndicator
		
		setCategory(unit.properties.category)
		setRestriction(unit.properties.restriction)
		setAccessibility(unit.properties.accessibility)
		
		//
		// Append the category, restriction and accessibility cells
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: [categoryCell, restrictionCell, accessibilityCell]
		))
	}

	func willCloseEditController() -> Void {
		unit.set(comment: commentCell.textField.text)

		try? Application.currentProject.imdfArchive.save(.unit)
	}
	
	/// Sets the category as a text value and writes it into the units properties
	/// - Parameter category: The category to write
	func setCategory(_ category: IMDFType.UnitCategory) -> Void {
		categoryCell.detailTextLabel?.text	= Localizable.IMDF.unitCategory(category)
		unit.properties.category			= category
	}
	
	/// Sets the restriction type as a text value and writes it into the units properties
	/// - Parameter restriction: The restriction type to write
	func setRestriction(_ restriction: IMDFType.Restriction?) -> Void {
		if let restriction = restriction {
			restrictionCell.detailTextLabel?.text = restriction.rawValue
		} else {
			restrictionCell.detailTextLabel?.text = Localizable.General.none
		}
		unit.properties.restriction = restriction
	}
	
	/// Sets the accessibility type as a text value and writes it into the units properties
	/// - Parameter accessibility: The accessibility type to write
	func setAccessibility(_ accessibility: [IMDFType.Accessibility]?) -> Void {
		if let accessibility = accessibility, accessibility.count > 0 {
			accessibilityCell.detailTextLabel?.text	= "\(accessibility.count)"
		} else {
			accessibilityCell.detailTextLabel?.text	= Localizable.General.none
		}
		unit.properties.accessibility = accessibility
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		
		if cell == categoryCell {
			let unitCategoryController				= FeatureUnitCategoryPickerController(style: .insetGrouped)
			unitCategoryController.currentCategory	= unit.properties.category
			unitCategoryController.delegate			= self
			navigationController?.pushViewController(unitCategoryController, animated: true)
		}
	}
}

extension UnitsEditController: FeatureUnitCategoryPickerDelegate {
	
	func unitCategoryPicker(_ pickerController: FeatureUnitCategoryPickerController, didPick category: IMDFType.UnitCategory) {
		setCategory(category)
		pickerController.navigationController?.popViewController(animated: true)
	}
	
}
