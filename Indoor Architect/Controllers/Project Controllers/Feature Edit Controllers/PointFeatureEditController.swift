//
//  PointFeatureEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import CoreLocation

class PointFeatureEditController: FeatureEditController, UITextFieldDelegate, FeatureDisplayPointControllerDelegate {
	
	/// The cell that will navigate to the display point editor
	let geometryCell = UITableViewCell(style: .default, reuseIdentifier: nil)
	
	var coordinates: CLLocationCoordinate2D?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		geometryCell.textLabel?.text	= Localizable.Feature.coordinates
		geometryCell.accessoryType		= .disclosureIndicator
		
		//
		// Append the latitude and longitude cells
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: [geometryCell]
		))
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return
		}
		
		if cell == geometryCell {
			let displayPointController					= FeatureDisplayPointController(style: .insetGrouped)
			displayPointController.displayPoint			= IMDFType.PointGeometry(coordinates: [coordinates?.longitude ?? 0, coordinates?.latitude ?? 0])
			displayPointController.delegate				= self
			navigationController?.pushViewController(displayPointController, animated: true)
		}
	}
	
	func geometryController(_ controller: FeatureDisplayPointController, didConfigureGeometryAs pointGeometry: IMDFType.PointGeometry?) {
		coordinates = nil
		if let point = pointGeometry {
			coordinates = point.getCoordinates()
		}
	}
}
