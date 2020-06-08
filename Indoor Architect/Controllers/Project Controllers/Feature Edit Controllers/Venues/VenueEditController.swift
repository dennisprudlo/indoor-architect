//
//  VenueEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/8/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class VenueEditController: PolygonalFeatureEditController, FeatureEditControllerDelegate {
	
	/// A reference to the venue that is being edited
	var venue: Venue!
	
	/// The cell that allows to edit the venues category
	var categoryCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the venues restriction type
	var restrictionCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the venues name
	var nameCell				= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows to edit the venues alternative name
	var alternativeNameCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell that allows the user to activate a curated display point
	var curatedDisplayPointCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	/// The cell which allows to edit the venues hours
	let hoursCell				= TextInputTableViewCell(placeholder: Localizable.Feature.hoursExample)
	
	/// The cell which allows to edit the venues phone number
	let phoneCell				= TextInputTableViewCell(placeholder: Localizable.Feature.phoneExample)
	
	/// The cell which allows to edit the venues website
	let websiteCell				= TextInputTableViewCell(placeholder: Localizable.Feature.websiteExample)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		super.prepareForFeature(with: venue.id, type: .venue, information: venue.properties.information, from: self)
		super.coordinates = venue.getCoordinates()
		
		//
		// Prepare PolygonFeatureEditController
		setGeometryEdges(count: venue.getCoordinates().count)
		
		title = "Edit Venue"
		
		//
		// Format the category, restriction and accessibility cells
		categoryCell.textLabel?.text			= Localizable.Feature.selectCategory
		restrictionCell.textLabel?.text			= Localizable.Feature.selectRestriction
		nameCell.textLabel?.text				= Localizable.Feature.selectName
		alternativeNameCell.textLabel?.text		= Localizable.Feature.selectAlternativeName
		curatedDisplayPointCell.textLabel?.text = Localizable.Feature.selectCuratedDisplayPoint
		
		hoursCell.textField.autocapitalizationType	= .none
		hoursCell.textField.autocorrectionType		= .no
		
		phoneCell.textField.keyboardType			= .namePhonePad
		phoneCell.textField.autocapitalizationType	= .none
		phoneCell.textField.autocorrectionType		= .no
		
		websiteCell.textField.keyboardType				= .webSearch
		websiteCell.textField.autocapitalizationType	= .none
		websiteCell.textField.autocorrectionType		= .no
		
		categoryCell.accessoryType				= .disclosureIndicator
		restrictionCell.accessoryType			= .disclosureIndicator
		nameCell.accessoryType					= .disclosureIndicator
		alternativeNameCell.accessoryType		= .disclosureIndicator
		curatedDisplayPointCell.accessoryType	= .disclosureIndicator
		
		setCategory(venue.properties.category)
		setRestriction(venue.properties.restriction)
		setName(venue.properties.name)
		setAlternativeName(venue.properties.altName)
		setCuratedDisplayPoint(venue.properties.displayPoint)
		hoursCell.textField.text = venue.properties.hours
		phoneCell.textField.text = venue.properties.phone
		websiteCell.textField.text = venue.properties.website
		
		//
		// Append the category, restriction and accessibility cells
		tableViewSections.append((
			title:			Localizable.Feature.properties,
			description:	nil,
			cells:			[
				categoryCell,
				restrictionCell,
				nameCell,
				alternativeNameCell,
				curatedDisplayPointCell
			]
		))
		
		tableViewSections.append((
			title:			Localizable.Feature.hoursTitle,
			description:	Localizable.Feature.hoursDescription,
			cells:			[hoursCell]
		))
		
		tableViewSections.append((
			title:			Localizable.Feature.phoneTitle,
			description:	Localizable.Feature.phoneDescription,
			cells:			[phoneCell]
		))
		
		tableViewSections.append((
			title:			Localizable.Feature.websiteTitle,
			description:	Localizable.Feature.websiteDescription,
			cells:			[websiteCell]
		))
	}
	
	func willCloseEditController() -> Void {
		venue.set(comment: commentCell.textField.text)
		venue.setCoordinates(super.coordinates)
		
		venue.properties.hours = hoursCell.textField.text
		venue.properties.phone = phoneCell.textField.text
		venue.properties.website = websiteCell.textField.text
		
		try? Application.currentProject.imdfArchive.save(.unit)
	}
	
	/// Sets the category as a text value and writes it into the venues properties
	/// - Parameter category: The category to write
	func setCategory(_ category: IMDFType.VenueCategory) -> Void {
		categoryCell.detailTextLabel?.text	= Localizable.IMDF.venueCategory(category)
		venue.properties.category			= category
	}
	
	/// Sets the restriction type as a text value and writes it into the venues properties
	/// - Parameter restriction: The restriction type to write
	func setRestriction(_ restriction: IMDFType.Restriction?) -> Void {
		if let restriction = restriction {
			restrictionCell.detailTextLabel?.text = Localizable.IMDF.restriction(restriction)
		} else {
			restrictionCell.detailTextLabel?.text = Localizable.General.none
		}
		venue.properties.restriction = restriction
	}
	
	/// Sets the venues name labels
	/// - Parameter name: The label set type to write
	func setName(_ name: IMDFType.Labels?) -> Void {
		if let name = name, name.count > 0 {
			nameCell.detailTextLabel?.text	= name.count == 1 ? name.first?.value : "Multiple (\(name.count))"
		} else {
			nameCell.detailTextLabel?.text	= Localizable.General.none
		}
		venue.properties.name = name
	}
	
	/// Sets the venues alternative name labels
	/// - Parameter alternativeName: The label set type to write
	func setAlternativeName(_ alternativeName: IMDFType.Labels?) -> Void {
		if let alternativeName = alternativeName, alternativeName.count > 0 {
			alternativeNameCell.detailTextLabel?.text	= alternativeName.count == 1 ? alternativeName.first?.value : "Multiple (\(alternativeName.count))"
		} else {
			alternativeNameCell.detailTextLabel?.text	= Localizable.General.none
		}
		venue.properties.altName = alternativeName
	}
	
	/// Sets the venues curated display point
	/// - Parameter displayPoint: The curated display point to set
	func setCuratedDisplayPoint(_ displayPoint: IMDFType.PointGeometry?) -> Void {
		curatedDisplayPointCell.detailTextLabel?.text	= displayPoint == nil ? Localizable.General.off : Localizable.General.on
		venue.properties.displayPoint					= displayPoint
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
		
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		
		if cell == categoryCell {
			let venueCategoryController				= VenueEditCategoryController(style: .insetGrouped)
			venueCategoryController.currentCategory	= venue.properties.category
			venueCategoryController.delegate		= self
			navigationController?.pushViewController(venueCategoryController, animated: true)
		}
		
		if cell == restrictionCell {
			let restrictionPicker					= FeatureRestrictionPickerController(style: .insetGrouped)
			restrictionPicker.currentRestriction	= venue.properties.restriction
			restrictionPicker.delegate				= self
			navigationController?.pushViewController(restrictionPicker, animated: true)
		}
		
		if cell == nameCell {
			let labelController			= FeatureLabelsController(style: .insetGrouped)
			labelController.title		= Localizable.Feature.selectName
			labelController.labels		= venue.properties.name
			labelController.delegate	= self
			labelController.identifier	= "name"
			navigationController?.pushViewController(labelController, animated: true)
		}

		if cell == alternativeNameCell {
			let labelController			= FeatureLabelsController(style: .insetGrouped)
			labelController.title		= Localizable.Feature.selectAlternativeName
			labelController.labels		= venue.properties.altName
			labelController.delegate	= self
			labelController.identifier	= "altName"
			navigationController?.pushViewController(labelController, animated: true)
		}

		if cell == curatedDisplayPointCell {
			let displayPointController					= FeatureDisplayPointController(style: .insetGrouped)
			displayPointController.allowsDeactivation	= true
			displayPointController.customTitle			= Localizable.Feature.selectCuratedDisplayPoint
			displayPointController.displayPoint			= venue.properties.displayPoint
			displayPointController.delegate				= self
			navigationController?.pushViewController(displayPointController, animated: true)
		}
	}
}

extension VenueEditController: VenueEditCategoryControllerDelegate {
	func venueCategory(_ controller: VenueEditCategoryController, didPick category: IMDFType.VenueCategory) {
		setCategory(category)
		controller.navigationController?.popViewController(animated: true)
	}
}

extension VenueEditController: FeatureRestrictionPickerDelegate {
	func restrictionPicker(_ pickerController: FeatureRestrictionPickerController, didDismissWith restriction: IMDFType.Restriction?) {
		setRestriction(restriction)
	}
}

extension VenueEditController: FeatureLabelsControllerDelegate {
	func labelController(_ controller: FeatureLabelsController, didConfigure labels: IMDFType.Labels?) {
		if controller.identifier == "name" {
			setName(labels)
		}
		
		if controller.identifier == "altName" {
			setAlternativeName(labels)
		}
	}
}

extension VenueEditController: FeatureDisplayPointControllerDelegate {
	func geometryController(_ controller: FeatureDisplayPointController, didConfigureGeometryAs pointGeometry: IMDFType.PointGeometry?) {
		setCuratedDisplayPoint(pointGeometry)
	}
}
