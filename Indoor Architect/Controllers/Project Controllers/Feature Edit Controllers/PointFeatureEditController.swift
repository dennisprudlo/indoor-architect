//
//  PointFeatureEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import CoreLocation

class PointFeatureEditController: FeatureEditController, UITextFieldDelegate {

	let latitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.latitude)
	let longitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.longitude)
	
	var coordinates: CLLocationCoordinate2D?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//
		// Store the default text input font
		let defaultFont = latitudeCell.textField.font
		
		latitudeCell.textField.font				= latitudeCell.textField.font?.monospaced()
		latitudeCell.textField.keyboardType		= .decimalPad
		latitudeCell.textField.delegate			= self
		latitudeCell.textField.text				= "\(coordinates?.latitude ?? 0)"
		
		longitudeCell.textField.font			= longitudeCell.textField.font?.monospaced()
		longitudeCell.textField.keyboardType	= .decimalPad
		longitudeCell.textField.delegate		= self
		longitudeCell.textField.text			= "\(coordinates?.longitude ?? 0)"
		
		latitudeCell.textField.addTarget(self, action: #selector(coordinatesInputChanged(_:)), for: .editingChanged)
		longitudeCell.textField.addTarget(self, action: #selector(coordinatesInputChanged(_:)), for: .editingChanged)
		
		if let font = defaultFont {
			let attributes = [ NSAttributedString.Key.font: font ]
			latitudeCell.textField.attributedPlaceholder = NSAttributedString(string: Localizable.Feature.latitude, attributes: attributes)
			longitudeCell.textField.attributedPlaceholder = NSAttributedString(string: Localizable.Feature.latitude, attributes: attributes)
		}
			
		tableViewSections.append((
			title: Localizable.Feature.coordinates,
			description: nil,
			cells: [latitudeCell, longitudeCell]
		))
    }
	
	@objc func coordinatesInputChanged(_ textField: UITextField) -> Void {
		notifiyChangesMade()
	}

	override func notifiyChangesMade() {
		super.notifiyChangesMade()
		
		guard let inputCoordinates = getInputCoordinates(), let coordinates = coordinates else {
			return
		}
		
		if !saveChangesButton.cellButton.isEnabled {
			saveChangesButton.setEnabled(inputCoordinates.latitude != coordinates.latitude || inputCoordinates.longitude != coordinates.longitude)
		}
	}
	
	func getInputCoordinates() -> CLLocationCoordinate2D? {
		guard let textFieldLatitude	= latitudeCell.textField.text, let textFieldLongitude = longitudeCell.textField.text else {
			return nil
		}
		
		guard let latitude = CLLocationDegrees(textFieldLatitude), let longitude = CLLocationDegrees(textFieldLongitude) else {
			return nil
		}
		
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == latitudeCell.textField || textField == longitudeCell.textField {
			let permittedCharacterSet	= CharacterSet(charactersIn:".0123456789")
			let textFieldCharacterSet	= CharacterSet(charactersIn: string)
			return permittedCharacterSet.isSuperset(of: textFieldCharacterSet)
		}
		return true
	}
}
