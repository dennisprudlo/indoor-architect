//
//  UnitsEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class UnitsEditController: PointFeatureEditController, FeatureEditControllerDelegate {

	/// A reference to the unit that is being edited
	var unit: Unit!
	
    override func viewDidLoad() {
		super.viewDidLoad()
		super.prepareForFeature(with: unit.id, information: unit.properties.information, from: self)
		
		//
		// Prepare PolygonFeatureEditController
		// TODO: --
		
		title = "Edit Unit"
    }

	func willCloseEditController() -> Void {
		unit.set(comment: commentCell.textField.text)

		try? Application.currentProject.imdfArchive.save(.unit)
	}
}
