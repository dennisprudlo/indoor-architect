//
//  AnchorsEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class AnchorsEditController: PointFeatureEditController, FeatureEditControllerDelegate, ProjectAddressControllerDelegate {
	
	/// A reference to the anchor that is being edited
	var anchor: Anchor!
	
	/// The address cell to pick a reference address
	let addressCell	= UITableViewCell(style: .subtitle, reuseIdentifier: nil)
	
	/// The unit cell to pick a reference unit
	let unitCell	= UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		
    override func viewDidLoad() {
        super.viewDidLoad()
		super.prepareForFeature(with: anchor.id, information: anchor.properties.information, from: self)
		
		//
		// Prepare PointFeatureEditController
		super.setInputCoordinates(anchor.getCoordinates())
		
		title = "Edit Anchor"
		
		//
		// Format the address and unit cells
		addressCell.accessoryType	= .disclosureIndicator
		unitCell.accessoryType		= .disclosureIndicator
		
		//
		// Initialize the address and unit cells
		setAddress(anchor.address)
		setUnit(nil)
		
		//
		// Add the address cell
		tableViewSections.append((
			title: "Address",
			description: Localizable.Feature.selectAddressDescription,
			cells: [addressCell]
		))
		
		//
		// Add the unit cell
		tableViewSections.append((
			title: "Unit",
			description: Localizable.Feature.selectUnitDescription,
			cells: [unitCell]
		))
    }

	func willCloseEditController() -> Void {
		anchor.set(comment: commentCell.textField.text)
		if let coordinates = getInputCoordinates() {
			anchor.setCoordinates(coordinates)
		}

		try? Application.currentProject.imdfArchive.save(.anchor)
	}
	
	/// Sets the address selection cell value
	/// - Parameter address: The address or nil if none selected
	private func setAddress(_ address: Address?) -> Void {
		anchor.address = address
		if let address = address {
			addressCell.textLabel?.text				= address.properties.address
			addressCell.detailTextLabel?.text		= address.getInlineLocality()
			addressCell.textLabel?.textColor		= .label
			addressCell.detailTextLabel?.textColor	= .label
		} else {
			addressCell.textLabel?.text				= Localizable.General.none
			addressCell.detailTextLabel?.text		= Localizable.Feature.selectAddressDetail
			addressCell.textLabel?.textColor		= .placeholderText
			addressCell.detailTextLabel?.textColor	= .placeholderText
		}
	}
	
	/// Sets the unit selection cell value
	/// - Parameter unit: The unit or nil if none selected
	private func setUnit(_ unit: Void?) -> Void {
		if let _ = unit {
			unitCell.textLabel?.text			= ""
			unitCell.detailTextLabel?.text		= ""
			unitCell.textLabel?.textColor		= .label
			unitCell.detailTextLabel?.textColor	= .label
		} else {
			unitCell.textLabel?.text			= Localizable.General.none
			unitCell.detailTextLabel?.text		= Localizable.Feature.selectUnitDetail
			unitCell.textLabel?.textColor		= .placeholderText
			unitCell.detailTextLabel?.textColor	= .placeholderText
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath) == addressCell {
			let addressPickerController			= ProjectAddressController(style: .insetGrouped)
			addressPickerController.address		= anchor.address
			addressPickerController.delegate	= self
			
			navigationController?.pushViewController(addressPickerController, animated: true)
		}
	}
	
	func addressPicker(_ picker: ProjectAddressController, didPickAddress address: Address?) {
		setAddress(address)
	}
}
