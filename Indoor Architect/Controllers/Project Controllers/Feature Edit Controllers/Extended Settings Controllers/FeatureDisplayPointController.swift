//
//  FeatureDisplayPointController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import CoreLocation

protocol FeatureDisplayPointControllerDelegate {
	func geometryController(_ controller: FeatureDisplayPointController, didConfigureGeometryAs pointGeometry: IMDFType.PointGeometry?) -> Void
}

class FeatureDisplayPointController: IATableViewController, UITextFieldDelegate {

	let activationCell	= SwitchTableViewCell()
	
	/// The cell that allows to edit the latitude value
	let latitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.latitude)
	
	/// The cell that allows to edit the longitude value
	let longitudeCell	= TextInputTableViewCell(placeholder: Localizable.Feature.longitude)
	
	/// A custom title to set
	var customTitle: String?
	
	/// If this is set to true an additional switch cell appears at the top enabling the user to activate or deactivate the display point
	/// When switch is activated on dismissal the coordinates are being returned, otherwise nil
	var allowsDeactivation: Bool = false
	
	/// The coordinates for the display point
	var displayPoint: IMDFType.PointGeometry?
	
	/// The delegate that handles the display point selection
	var delegate: FeatureDisplayPointControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = customTitle == nil ? Localizable.Feature.coordinates : customTitle
		
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
			latitudeCell.textField.attributedPlaceholder = NSAttributedString(string: "0.0", attributes: attributes)
			longitudeCell.textField.attributedPlaceholder = NSAttributedString(string: "0.0", attributes: attributes)
		}
		
		if allowsDeactivation {
			activationCell.textLabel?.text = Localizable.Feature.useCuratedDisplayPoint
			activationCell.cellSwitch.addTarget(self, action: #selector(didSwitch(_:)), for: .valueChanged)
			
			activationCell.cellSwitch.setOn(displayPoint != nil, animated: true)
			
			tableViewSections.append((
				title: nil,
				description: Localizable.Feature.curatedDisplayPointDescription,
				cells: [activationCell]
			))
			
			didSwitch(activationCell.cellSwitch)
		}
		
		if let point = displayPoint {
			latitudeCell.textField.text		= "\(point.getCoordinates().latitude)"
			longitudeCell.textField.text	= "\(point.getCoordinates().longitude)"
		}
		
		//
		// Append the latitude and longitude cells only if
		// the switch is not added. In that case we manually animate
		// the cells in.
		if !allowsDeactivation {
			tableViewSections.append((
				title: Localizable.Feature.latitude,
				description: nil,
				cells: [latitudeCell]
			))
			tableViewSections.append((
				title: Localizable.Feature.longitude,
				description: nil,
				cells: [longitudeCell]
			))
		}
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//
		// If the view controller is being dismissed (closed) we want to collect
		// the coordinates and return it to the delegate
		if isMovingFromParent {
			var pointGeometry: IMDFType.PointGeometry? = nil
			
			//
			// If the user can select whether to use the display point or not we always return a point geometry.
			// If the input coordinates could not be retrieved we return a display point of 0, 0.
			if allowsDeactivation {
				if let inputCoordinates = getInputCoordinates() {
					pointGeometry = IMDFType.PointGeometry(coordinates: [inputCoordinates.longitude, inputCoordinates.latitude])
				} else {
					pointGeometry = IMDFType.PointGeometry(coordinates: [0, 0])
				}
				
				//
				// If the user has disabled the curated display point, we return nil though
				if !activationCell.cellSwitch.isOn {
					pointGeometry = nil
				}
			}
			
			//
			// If the user can not select whether to use a point or not (when updating an anchors actual coordinates f.i.)
			// we return the input point geometry. If if cannot be retrieved we return nil
			if !allowsDeactivation {
				if let inputCoordinates = getInputCoordinates() {
					pointGeometry = IMDFType.PointGeometry(coordinates: [inputCoordinates.longitude, inputCoordinates.latitude])
				} else {
					pointGeometry = nil
				}
			}
	
			delegate?.geometryController(self, didConfigureGeometryAs: pointGeometry)
		}
	}
	
	@objc func didSwitch(_ control: UISwitch) -> Void {
		latitudeCell.textField.text		= nil
		longitudeCell.textField.text	= nil
		
		if control.isOn {
			showCoordinatesInput()
		} else {
			hideCoordinatesInput()
		}
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
	
	private func hideCoordinatesInput() -> Void {
		
		//
		// Only hide the inputs if they are currently visible
		if tableViewSections.count != 3 {
			return
		}
		
		tableViewSections.removeLast()
		tableViewSections.removeLast()

		tableView.beginUpdates()
		tableView.deleteSections(IndexSet(1...2), with: .fade)
		tableView.endUpdates()
	}
	
	private func showCoordinatesInput() -> Void {

		//
		// Only show the inputs if they are currently hidden
		if tableViewSections.count != 1 {
			return
		}
		
		tableViewSections.append((
			title: Localizable.Feature.latitude,
			description: nil,
			cells: [latitudeCell]
		))
		tableViewSections.append((
			title: Localizable.Feature.longitude,
			description: nil,
			cells: [longitudeCell]
		))
		
		tableView.beginUpdates()
		tableView.insertSections(IndexSet(1...2), with: .fade)
		tableView.endUpdates()
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
