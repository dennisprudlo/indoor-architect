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
	
	let featureIdCell			= UITableViewCell(style: .default, reuseIdentifier: nil)
	let addressCell				= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderAddress)
	let countryCell				= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let provinceCell			= UITableViewCell(style: .value1, reuseIdentifier: nil)
	let localityCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderLocality)
	let postalCodeCell			= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderCode)
	let postalCodeExtensionCell	= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderExtension)
	let postalCodeVanityCell	= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderVanity)
	let unitCell				= TextInputTableViewCell(placeholder: Localizable.ProjectExplorer.Project.Address.placeholderUnit)
	
	var countryData: Address.LocalityCodeCombination? {
		didSet {
			provinceData = nil
		}
	}
	var provinceData: Address.LocalityCodeCombination?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = UITableView.automaticDimension
		
		//
		// Set the confirm button title
		confirmButtonTitle = shouldRenderToCreate ? Localizable.ProjectExplorer.Project.Address.add : Localizable.ProjectExplorer.Project.Address.delete
		
		//
		// Set the controller title
		title = shouldRenderToCreate ? Localizable.ProjectExplorer.Project.Address.addAddress : Localizable.ProjectExplorer.Project.Address.editAddress
		
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
			tableView.cellLayoutMarginsFollowReadableWidth	= true
			tableView.backgroundColor						= Color.lightStyleTableViewBackground
			tableView.separatorColor						= Color.lightStyleCellSeparatorColor
			
			navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
			
			tableViewSections.append((title: "Feature ID", description: nil, cells: [featureIdCell]))
			
			featureIdCell.selectionStyle			= .none
			featureIdCell.textLabel?.isEnabled		= false
			
			featureIdCell.textLabel?.text			= addressToEdit?.id.uuidString
			addressCell.textField.text				= addressToEdit?.properties.address
			countryData								= addressToEdit?.getCountryData()
			provinceData							= addressToEdit?.getSubdivisionData()
			localityCell.textField.text				= addressToEdit?.properties.locality
			postalCodeCell.textField.text			= addressToEdit?.properties.postalCode
			postalCodeExtensionCell.textField.text	= addressToEdit?.properties.postalCodeExt
			postalCodeVanityCell.textField.text		= addressToEdit?.properties.postalCodeVanity
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
			cells:			[postalCodeCell, postalCodeExtensionCell, postalCodeVanityCell]
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
			countryCell.textLabel?.text = countryData.title
			countryCell.textLabel?.textColor = .label
		} else {
			countryCell.textLabel?.text = Localizable.ProjectExplorer.Project.Address.placeholderCountry
			countryCell.textLabel?.textColor = .placeholderText
		}
		
		if let provinceData = self.provinceData {
			provinceCell.textLabel?.text = provinceData.title
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
		
		//
		// The controller shows the delete button instead
		if !shouldRenderToCreate {
			if let visibleAddress = addressToEdit {
				displayController.project.imdfArchive.addresses.removeAll { (address) -> Bool in
					return address.id.uuidString == visibleAddress.id.uuidString
				}
				displayController.tableView.reloadData()
			}
		} else {
		
			guard
				let address = addressCell.textField.text,
				let country = countryData?.code,
				let province = provinceData?.code,
				let locality = localityCell.textField.text
			else {
				return
			}
			
			let unitValue = unitCell.textField.text
			let postalCodeValue = postalCodeCell.textField.text
			let postalCodeExtValue = postalCodeExtensionCell.textField.text
			let postalCodeVanityValue = postalCodeVanityCell.textField.text
			
			let uuid = displayController.project.imdfArchive.getUnusedGlobalUuid()
			let properties = Address.Properties(
				address:			address,
				unit:				unitValue?.count ?? 0 == 0 ? nil : unitValue,
				locality:			locality,
				province:			province,
				country:			country,
				postalCode:			postalCodeValue?.count ?? 0 == 0 ? nil : postalCodeValue,
				postalCodeExt:		postalCodeExtValue?.count ?? 0 == 0 ? nil : postalCodeExtValue,
				postalCodeVanity:	postalCodeVanityValue?.count ?? 0 == 0 ? nil : postalCodeVanityValue
			)
			
			let addressToAdd = Address(withIdentifier: uuid, properties: properties, geometry: [], type: .address)
			displayController.project.imdfArchive.addresses.append(addressToAdd)
			displayController.tableView.reloadData()
		}
		
		do {
			let archive = displayController.project.imdfArchive
			try archive.save(.address)
		} catch {
			print(error)
		}
		
			
		if !shouldRenderToCreate {
			navigationController?.popViewController(animated: true)
		} else {
			dismiss(animated: true, completion: nil)
		}
	}
	
	private func checkAddAddressButtonState() -> Void {
		if !shouldRenderToCreate {
			isConfirmButtonEnabled = true
			return
		}
		
		guard let address = addressCell.textField.text, let locality = localityCell.textField.text, let _ = countryData, let _ = provinceData else {
			isConfirmButtonEnabled = false
			return
		}

		if address.count == 0 || locality.count == 0 {
			isConfirmButtonEnabled = false
			return
		}

		isConfirmButtonEnabled = true
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableViewSections[indexPath.section].cells[indexPath.row]
		
		if !shouldRenderToCreate {
			cell.backgroundColor = Color.lightStyleCellBackground
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		if cell == countryCell {
			let localePickerController					= ProjectAddressLocaleController(style: .insetGrouped)
			localePickerController.displayController	= self
			localePickerController.dataType				= .country
			navigationController?.pushViewController(localePickerController, animated: true)
		} else if cell == provinceCell {
			
			guard let code = countryData?.code else {
				return tableView.deselectRow(at: indexPath, animated: true)
			}
			
			let localePickerController					= ProjectAddressLocaleController(style: .insetGrouped)
			localePickerController.displayController	= self
			localePickerController.dataType				= .province
			localePickerController.preselectedCountry	= code
			navigationController?.pushViewController(localePickerController, animated: true)
		}
	}
}
