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
	
	/// The cell that allows to edit the latitude value
	let latitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.latitude)
	
	/// The cell that allows to edit the longitude value
	let longitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.longitude)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//
		// Store the default text input font
		let defaultFont = latitudeCell.textField.font
		
		//
		// Format the latitude textField
		latitudeCell.textField.font				= latitudeCell.textField.font?.monospaced()
		latitudeCell.textField.keyboardType		= .decimalPad
		latitudeCell.textField.delegate			= self
		
		//
		// Format the longitude textField
		longitudeCell.textField.font			= longitudeCell.textField.font?.monospaced()
		longitudeCell.textField.keyboardType	= .decimalPad
		longitudeCell.textField.delegate		= self
		
		//
		// Use the default font for the placeholder
		if let font = defaultFont {
			let attributes = [ NSAttributedString.Key.font: font ]
			latitudeCell.textField.attributedPlaceholder = NSAttributedString(string: Localizable.Feature.latitude, attributes: attributes)
			longitudeCell.textField.attributedPlaceholder = NSAttributedString(string: Localizable.Feature.latitude, attributes: attributes)
		}
		
		//
		// Append the latitude and longitude cells
		tableViewSections.append((
			title: Localizable.Feature.coordinates,
			description: nil,
			cells: [latitudeCell, longitudeCell]
		))
    }
	
	/// Gets the coordinates from the textField Inputs
	/// - Returns: The coordinates or nil if the values are invalid
	func getInputCoordinates() -> CLLocationCoordinate2D? {
		guard let textFieldLatitude	= latitudeCell.textField.text, let textFieldLongitude = longitudeCell.textField.text else {
			return nil
		}
		
		guard let latitude = CLLocationDegrees(textFieldLatitude), let longitude = CLLocationDegrees(textFieldLongitude) else {
			return nil
		}
		
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
	
	/// Sets the coordinates for the textFields
	/// - Parameter coordinates: The coordinates to set
	func setInputCoordinates(_ coordinates: CLLocationCoordinate2D) -> Void {
		latitudeCell.textField.text		= "\(coordinates.latitude)"
		longitudeCell.textField.text	= "\(coordinates.longitude)"
	}
	
	/// Validates the character input in the latitude and longitude cells and determines whether the changes should be applied or not
	/// - Parameters:
	///   - textField: The textField being edited
	///   - range: The range of characters to be replaced
	///   - string: The content of the textField
	/// - Returns: Whether to apply the changes
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == latitudeCell.textField || textField == longitudeCell.textField {
			let permittedCharacterSet	= CharacterSet(charactersIn:".0123456789")
			let textFieldCharacterSet	= CharacterSet(charactersIn: string)
			return permittedCharacterSet.isSuperset(of: textFieldCharacterSet)
		}
		return true
	}
}
