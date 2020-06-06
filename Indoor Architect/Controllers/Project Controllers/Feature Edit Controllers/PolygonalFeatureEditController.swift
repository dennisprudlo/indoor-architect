//
//  PolygonalFeatureEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/12/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import CoreLocation

class PolygonalFeatureEditController: FeatureEditController, FeatureCoordinatesControllerDelegate {
	
	/// The cell that will navigate to the polygonal geometry coordinates editor
	let geometryCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	
	var coordinates: [CLLocationCoordinate2D] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

		//
		// Adds the change feature bar button item to select a feature type
		addNavigationBarButton(UIBarButtonItem(title: "Change Feature", style: .plain, target: self, action: #selector(changeFeatureType(_:))), animated: true)
		
		//
		// Format the geometry text field
		geometryCell.textLabel?.text		= Localizable.Feature.coordinates
		geometryCell.accessoryType			= .disclosureIndicator
		setGeometryEdges(count: 0)
		
		//
		// Append the geometry cell
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: [geometryCell]
		))
    }
	
	@objc func changeFeatureType(_ barButtonItem: UIBarButtonItem) -> Void {
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return
		}
		
		if cell == geometryCell {
			let coordinatesController			= FeatureCoordinatesController(style: .insetGrouped)
			coordinatesController.coordinates	= coordinates
			coordinatesController.delegate		= self
			navigationController?.pushViewController(coordinatesController, animated: true)
		}
	}
	
	func geometryController(_ controller: FeatureCoordinatesController, didConfigureCoordinates coordinates: [CLLocationCoordinate2D]) {
		self.coordinates = coordinates
	}
	
	func setGeometryEdges(count: Int) -> Void {
		geometryCell.detailTextLabel?.text	= count <= 0 ? Localizable.General.none : "\(count) Points"
	}
}
