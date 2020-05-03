//
//  AnchorsEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class AnchorsEditController: PointFeatureEditController, PromisesFeatureDeleteHandler {

	var anchor: Anchor!
	
	let addressCell	= UITableViewCell(style: .subtitle, reuseIdentifier: nil)
	let unitCell	= UITableViewCell(style: .default, reuseIdentifier: nil)
	
	var address: Address?
	
    override func viewDidLoad() {
		coordinates = anchor.getCoordinates()
		
        super.viewDidLoad()
		super.propagateFeature(anchor, of: Anchor.Properties.self, information: anchor.properties.information)
		
		deleteHandlerDelegate = self
		
		title = "Edit Anchor"
		
		addressCell.accessoryType			= .disclosureIndicator
		setAddress(anchor.address)
		
		unitCell.textLabel?.text = anchor.properties.unitId?.uuidString
		
		tableViewSections.append((
			title: "Address",
			description: Localizable.Feature.selectAddressDescription,
			cells: [addressCell]
		))
		tableViewSections.append((
			title: "Unit",
			description: nil,
			cells: [unitCell]
		))
    }

	override func didTapSaveChanges(_ button: UIButton) {
		anchor.set(comment: commentCell.textField.text)
		if let coordinates = getInputCoordinates() {
			anchor.setCoordinates(coordinates)
			anchor.address = address
			canvas?.generateIMDFOverlays()
		}
		
		do {
			try project.imdfArchive.save(.anchor)
			
			coordinates = anchor.getCoordinates()
			
			super.propagateFeature(anchor, of: Anchor.Properties.self, information: anchor.properties.information)
			super.notifiyChangesMade()
		} catch {
			print(error)
		}
	}
	
	override func notifiyChangesMade() {
		super.notifiyChangesMade()
		if !saveChangesButton.cellButton.isEnabled {
			saveChangesButton.setEnabled(address?.id.uuidString ?? "" != anchor.address?.id.uuidString ?? "")
		}
	}
	
	func setAddress(_ address: Address?) -> Void {
		self.address = address
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
	
	func delete() {
		project.imdfArchive.delete(anchor)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath) == addressCell {
			let addressPickerController = ProjectAddressController(style: .insetGrouped)
			addressPickerController.project = project
			addressPickerController.currentlySelectedAddress = address
			addressPickerController.didSelectAddress = { address in
				self.setAddress(address)
				self.notifiyChangesMade()
			}
			
			navigationController?.pushViewController(addressPickerController, animated: true)
		}
	}
}
