//
//  ProjectAddressEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class ProjectAddressEditController: ComposePopoverController {
	
	var displayController: ProjectAddressController!
	var shouldRenderToCreate: Bool = false
	var addressToEdit: Address?
	
	let featureIdCell		= UITableViewCell(style: .default, reuseIdentifier: nil)
	let addressCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderAddress)
	let countryCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let provinceCell		= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let localityCell		= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderLocality)
	let postalCodeCell		= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderCode)
	let postalCodeExtension	= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderExtension)
	let postalCodeVanity	= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderVanity)
	let unitCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderUnit)
	
	var countryData: (displayTitle: String, code: String)?
	var provinceData: (displayTitle: String, code: String)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		// Set the confirm button title
		confirmButtonTitle = Localizable.ProjectExplorer.Project.Address.add
		
		//
		// Set the controller title
		title = Localizable.ProjectExplorer.Project.Address.addAddress
		
		
		//
		// Configure the table view itself
		tableView.rowHeight = 44
		
		//
		// Configure table view cells
		countryCell.textLabel?.text			= Localizable.ProjectExplorer.Project.Address.placeholderCountry
		countryCell.textLabel?.textColor	= .placeholderText
		countryCell.accessoryType			= .disclosureIndicator
		
		provinceCell.textLabel?.text		= Localizable.ProjectExplorer.Project.Address.placeholderProvince
		provinceCell.textLabel?.textColor	= .placeholderText
		provinceCell.accessoryType			= .disclosureIndicator
		
		//
		// Configure cell event handler
		for cell in [addressCell, localityCell] {
			cell.textField.addTarget(self, action: #selector(didChangeText(in:)), for: .editingChanged)
		}
		
		//
		// Set the address cell to become the first responder
		addressCell.textField.becomeFirstResponder()
		
		//
		// Configure the table view sections
		if !shouldRenderToCreate {
			featureIdCell.textLabel?.text = addressToEdit?.id.uuidString
			tableViewSections.append((title: "Feature ID", description: nil, cells: [featureIdCell]))
		}
		tableViewSections.append((
			title: nil,
			description: Localizable.ProjectExplorer.Project.Address.addressDescription,
			cells: [addressCell]
		))
		tableViewSections.append((
			title:			nil,
			description:	nil,
			cells:			[countryCell, provinceCell, localityCell]
		))
		tableViewSections.append((
			title:			Localizable.ProjectExplorer.Project.Address.postalCode,
			description:	Localizable.ProjectExplorer.Project.Address.postalCodeDescription,
			cells:			[postalCodeCell, postalCodeExtension, postalCodeVanity]
		))
		tableViewSections.append((
			title:			Localizable.ProjectExplorer.Project.Address.unit,
			description:	Localizable.ProjectExplorer.Project.Address.unitDescription,
			cells:			[unitCell]
		))
		tableViewSections.append((
			title:			nil,
			description:	nil,
			cells:			[confirmButtonCell]
		))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let countryData = self.countryData {
			countryCell.textLabel?.text = countryData.displayTitle
			countryCell.textLabel?.textColor = .label
		} else {
			countryCell.textLabel?.text = Localizable.ProjectExplorer.Project.Address.placeholderCountry
			countryCell.textLabel?.textColor = .placeholderText
		}
		
		if let provinceData = self.provinceData {
			provinceCell.textLabel?.text = provinceData.displayTitle
			provinceCell.textLabel?.textColor = .label
		} else {
			provinceCell.textLabel?.text = Localizable.ProjectExplorer.Project.Address.placeholderProvince
			provinceCell.textLabel?.textColor = .placeholderText
		}
		
		checkAddAddressButtonState()
	}
	
	@objc func didChangeText(in textField: UITextField) -> Void {
		checkAddAddressButtonState()
	}
	
	override func didTapCreate(_ sender: UIButton) -> Void {
		guard
			let address = addressCell.textField.text,
			let country = countryData?.code,
			let province = provinceData?.code,
			let locality = localityCell.textField.text
		else {
			return
		}
		
		var unit: String? = nil
		if let unitValue = unitCell.textField.text, unitValue.count > 0 {
			unit = unitValue
		}
		
		let uuid = displayController.project.imdfArchive.getUnusedGlobalUuid()
		let properties = Address.Properties(
			address:			address,
			unit:				unit,
			locality:			locality,
			province:			province,
			country:			country,
			postalCode:			postalCodeCell.textField.text,
			postalCodeExt:		postalCodeExtension.textField.text,
			postalCodeVanity:	postalCodeVanity.textField.text
		)
		
		let addressToAdd = Address(withIdentifier: uuid, properties: properties, geometry: [])
		displayController.project.imdfArchive.addresses.append(addressToAdd)
		displayController.tableView.reloadData()
		
		dismiss(animated: true, completion: nil)
	}
	
	private func checkAddAddressButtonState() -> Void {
		guard let address = addressCell.textField.text, let locality = localityCell.textField.text, let _ = countryData else {
			isConfirmButtonEnabled = false
			return
		}

		if address.count == 0 || locality.count == 0 {
			isConfirmButtonEnabled = false
			return
		}

		isConfirmButtonEnabled = true
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		if cell == countryCell {
			let localePickerController = ProjectAddressLocaleController(style: .insetGrouped)
			localePickerController.displayController = self
			localePickerController.dataType = .country
			navigationController?.pushViewController(localePickerController, animated: true)
		} else if cell == provinceCell {
			let localePickerController = ProjectAddressLocaleController(style: .insetGrouped)
			localePickerController.displayController = self
			localePickerController.dataType = .province
			navigationController?.pushViewController(localePickerController, animated: true)
		}
	}
}
