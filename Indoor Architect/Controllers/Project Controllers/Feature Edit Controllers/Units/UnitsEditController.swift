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
	var categoryCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the units restriction type
	var restrictionCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the units accessibility type
	var accessibilityCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the units name
	var nameCell				= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the units alternative name
	var alternativeNameCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows the user to activate a curated display point
	var curatedDisplayPointCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	
    override func viewDidLoad() {
		super.viewDidLoad()
		super.prepareForFeature(with: unit.id, information: unit.properties.information, from: self)
		super.coordinates = unit.getCoordinates()
		
		//
		// Prepare PolygonFeatureEditController
		setGeometryEdges(count: unit.getCoordinates().count)
	
		title = "Edit Unit"
		
		//
		// Format the category, restriction and accessibility cells
		categoryCell.textLabel?.text			= Localizable.Feature.selectCategory
		restrictionCell.textLabel?.text			= Localizable.Feature.selectRestriction
		accessibilityCell.textLabel?.text		= Localizable.Feature.selectAccessibility
		nameCell.textLabel?.text				= Localizable.Feature.selectName
		alternativeNameCell.textLabel?.text		= Localizable.Feature.selectAlternativeName
		curatedDisplayPointCell.textLabel?.text = Localizable.Feature.selectCuratedDisplayPoint
		
		categoryCell.accessoryType				= .disclosureIndicator
		restrictionCell.accessoryType			= .disclosureIndicator
		accessibilityCell.accessoryType			= .disclosureIndicator
		nameCell.accessoryType					= .disclosureIndicator
		alternativeNameCell.accessoryType		= .disclosureIndicator
		curatedDisplayPointCell.accessoryType	= .disclosureIndicator
		
		setCategory(unit.properties.category)
		setRestriction(unit.properties.restriction)
		setAccessibility(unit.properties.accessibility)
		setName(unit.properties.name)
		setAlternativeName(unit.properties.altName)
		setCuratedDisplayPoint(unit.properties.displayPoint)
		
		//
		// Append the category, restriction and accessibility cells
		tableViewSections.append((
			title:			Localizable.Feature.properties,
			description:	nil,
			cells:			[
				categoryCell,
				restrictionCell,
				accessibilityCell,
				nameCell,
				alternativeNameCell,
				curatedDisplayPointCell
			]
		))
	}

	func willCloseEditController() -> Void {
		unit.set(comment: commentCell.textField.text)
		unit.setCoordinates(super.coordinates)
		
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
			restrictionCell.detailTextLabel?.text = Localizable.IMDF.restriction(restriction)
		} else {
			restrictionCell.detailTextLabel?.text = Localizable.General.none
		}
		unit.properties.restriction = restriction
	}
	
	/// Sets the accessibility type as a text value and writes it into the units properties
	/// - Parameter accessibility: The accessibility type to write
	func setAccessibility(_ accessibility: [IMDFType.Accessibility]?) -> Void {
		if let accessibility = accessibility, accessibility.count > 0 {
			accessibilityCell.detailTextLabel?.text	= accessibility.count == 1 ? Localizable.IMDF.accessibility(accessibility.first!) : "Multiple (\(accessibility.count))"
		} else {
			accessibilityCell.detailTextLabel?.text	= Localizable.General.none
		}
		unit.properties.accessibility = accessibility
	}
	
	/// Sets the units name labels
	/// - Parameter name: The label set type to write
	func setName(_ name: IMDFType.Labels?) -> Void {
		if let name = name, name.count > 0 {
			nameCell.detailTextLabel?.text	= name.count == 1 ? name.first?.value : "Multiple (\(name.count))"
		} else {
			nameCell.detailTextLabel?.text	= Localizable.General.none
		}
		unit.properties.name = name
	}
	
	/// Sets the units alternative name labels
	/// - Parameter alternativeName: The label set type to write
	func setAlternativeName(_ alternativeName: IMDFType.Labels?) -> Void {
		if let alternativeName = alternativeName, alternativeName.count > 0 {
			alternativeNameCell.detailTextLabel?.text	= alternativeName.count == 1 ? alternativeName.first?.value : "Multiple (\(alternativeName.count))"
		} else {
			alternativeNameCell.detailTextLabel?.text	= Localizable.General.none
		}
		unit.properties.altName = alternativeName
	}
	
	/// Sets the units curated display point
	/// - Parameter displayPoint: The curated display point to set
	func setCuratedDisplayPoint(_ displayPoint: IMDFType.PointGeometry?) -> Void {
		curatedDisplayPointCell.detailTextLabel?.text	= displayPoint == nil ? Localizable.General.off : Localizable.General.on
		unit.properties.displayPoint					= displayPoint
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
		
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		
		if cell == categoryCell {
			let unitCategoryController				= FeatureUnitCategoryPickerController(style: .insetGrouped)
			unitCategoryController.currentCategory	= unit.properties.category
			unitCategoryController.delegate			= self
			navigationController?.pushViewController(unitCategoryController, animated: true)
		}
		
		if cell == restrictionCell {
			let restrictionPicker					= FeatureRestrictionPickerController(style: .insetGrouped)
			restrictionPicker.currentRestriction	= unit.properties.restriction
			restrictionPicker.delegate				= self
			navigationController?.pushViewController(restrictionPicker, animated: true)
		}
		
		if cell == accessibilityCell {
			let accessibilityPicker						= FeatureAccessibilityPickerController(style: .insetGrouped)
			accessibilityPicker.currentAccessibilities	= unit.properties.accessibility
			accessibilityPicker.delegate				= self
			navigationController?.pushViewController(accessibilityPicker, animated: true)
		}
		
		if cell == nameCell {
			let labelController			= FeatureLabelsController(style: .insetGrouped)
			labelController.title		= Localizable.Feature.selectName
			labelController.labels		= unit.properties.name
			labelController.delegate	= self
			labelController.identifier	= "name"
			navigationController?.pushViewController(labelController, animated: true)
		}
		
		if cell == alternativeNameCell {
			let labelController			= FeatureLabelsController(style: .insetGrouped)
			labelController.title		= Localizable.Feature.selectAlternativeName
			labelController.labels		= unit.properties.altName
			labelController.delegate	= self
			labelController.identifier	= "altName"
			navigationController?.pushViewController(labelController, animated: true)
		}
		
		if cell == curatedDisplayPointCell {
			let displayPointController					= FeatureDisplayPointController(style: .insetGrouped)
			displayPointController.allowsDeactivation	= true
			displayPointController.customTitle			= Localizable.Feature.selectCuratedDisplayPoint
			displayPointController.displayPoint			= unit.properties.displayPoint
			displayPointController.delegate				= self
			navigationController?.pushViewController(displayPointController, animated: true)
		}
	}
}

extension UnitsEditController: FeatureUnitCategoryPickerDelegate {
	func unitCategoryPicker(_ pickerController: FeatureUnitCategoryPickerController, didPick category: IMDFType.UnitCategory) {
		setCategory(category)
		pickerController.navigationController?.popViewController(animated: true)
	}
}

extension UnitsEditController: FeatureAccessibilityPickerDelegate {
	func accessibilityPicker(_ pickerController: FeatureAccessibilityPickerController, didDismissWith accessibilities: [IMDFType.Accessibility]?) {
		setAccessibility(accessibilities)
	}
}

extension UnitsEditController: FeatureRestrictionPickerDelegate {
	func restrictionPicker(_ pickerController: FeatureRestrictionPickerController, didDismissWith restriction: IMDFType.Restriction?) {
		setRestriction(restriction)
	}
}

extension UnitsEditController: FeatureLabelsControllerDelegate {
	func labelController(_ controller: FeatureLabelsController, didConfigure labels: IMDFType.Labels?) {
		if controller.identifier == "name" {
			setName(labels)
		}
		
		if controller.identifier == "altName" {
			setAlternativeName(labels)
		}
	}
}

extension UnitsEditController: FeatureDisplayPointControllerDelegate {
	func geometryController(_ controller: FeatureDisplayPointController, didConfigureGeometryAs pointGeometry: IMDFType.PointGeometry?) {
		setCuratedDisplayPoint(pointGeometry)
	}
}
