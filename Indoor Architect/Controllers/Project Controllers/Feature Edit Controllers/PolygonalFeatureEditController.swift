//
//  PolygonalFeatureEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/12/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class PolygonalFeatureEditController: FeatureEditController {
	
	/// The cell that will navigate to the polygonal geometry coordinates editor
	let geometryCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
	
    override func viewDidLoad() {
        super.viewDidLoad()

		//
		// Adds the change feature bar button item to select a feature type
		addNavigationBarButton(UIBarButtonItem(title: "Change Feature", style: .plain, target: self, action: #selector(changeFeatureType(_:))), animated: true)
		
		//
		// Format the geometry text field
		geometryCell.textLabel?.text		= "Geometry"
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
	
	func setGeometryEdges(count: Int) -> Void {
		geometryCell.detailTextLabel?.text	= count <= 0 ? Localizable.General.none : "\(count) Points"
	}
}
