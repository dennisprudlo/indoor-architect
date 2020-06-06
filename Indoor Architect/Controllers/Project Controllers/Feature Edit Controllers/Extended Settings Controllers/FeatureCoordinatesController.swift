//
//  FeatureCoordinatesController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/6/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import CoreLocation

protocol FeatureCoordinatesControllerDelegate {
	func geometryController(_ controller: FeatureCoordinatesController, didConfigureCoordinates coordinates: [CLLocationCoordinate2D]) -> Void
}

class FeatureCoordinatesController: IATableViewController, UITextFieldDelegate {
	
	var coordinates: [CLLocationCoordinate2D] = []
	
	var delegate: FeatureCoordinatesControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Localizable.Feature.coordinates
		
		var counter = 1
		coordinates.forEach { (coordinate) in
			let latitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.latitude)
			let longitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.longitude)
			
			let defaultFont		= latitudeCell.textField.font
			
			latitudeCell.textField.font				= latitudeCell.textField.font?.monospaced()
			latitudeCell.textField.keyboardType		= .decimalPad
			latitudeCell.textField.text				= "\(coordinate.latitude)"
			latitudeCell.textField.delegate			= self

			longitudeCell.textField.font			= longitudeCell.textField.font?.monospaced()
			longitudeCell.textField.keyboardType	= .decimalPad
			longitudeCell.textField.text			= "\(coordinate.longitude)"
			longitudeCell.textField.delegate		= self
			
			if let font = defaultFont {
				let attributes = [ NSAttributedString.Key.font: font ]
				latitudeCell.textField.attributedPlaceholder = NSAttributedString(string: Localizable.Feature.latitude, attributes: attributes)
				longitudeCell.textField.attributedPlaceholder = NSAttributedString(string: Localizable.Feature.longitude, attributes: attributes)
			}
			
			appendSection(cells: [latitudeCell, longitudeCell], title: "\(Localizable.Feature.coordinates) #\(counter)", description: nil)
			
			counter += 1
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//
		// If the view controller is being dismissed (closed) we want to collect
		// the coordinates and return it to the delegate
		if isMovingFromParent, let coordinates = getInputCoordinates() {
			delegate?.geometryController(self, didConfigureCoordinates: coordinates)
		}
	}
	
	/// Gets the coordinates from the textField Inputs
	/// - Returns: The coordinates or nil if the values are invalid
	func getInputCoordinates() -> [CLLocationCoordinate2D]? {
		var coordinates: [CLLocationCoordinate2D] = []
		
		for section in tableViewSections {
			guard let latitudeCell = section.cells.first as? TextInputTableViewCell, let longitudeCell = section.cells.last as? TextInputTableViewCell else {
				return nil
			}
			
			guard let textFieldLatitude	= latitudeCell.textField.text, let textFieldLongitude = longitudeCell.textField.text else {
				return nil
			}
			
			guard let latitude = CLLocationDegrees(textFieldLatitude), let longitude = CLLocationDegrees(textFieldLongitude) else {
				return nil
			}
			
			coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
		}
		
		//
		// The input coordinates are only valid if they have the same amount of tuples
		if self.coordinates.count != coordinates.count {
			return nil
		}
		
		return coordinates
	}
	
	/// Validates the character input in the latitude and longitude cells and determines whether the changes should be applied or not
	/// - Parameters:
	///   - textField: The textField being edited
	///   - range: The range of characters to be replaced
	///   - string: The content of the textField
	/// - Returns: Whether to apply the changes
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let permittedCharacterSet	= CharacterSet(charactersIn:".0123456789")
		let textFieldCharacterSet	= CharacterSet(charactersIn: string)
		return permittedCharacterSet.isSuperset(of: textFieldCharacterSet)
	}
}
