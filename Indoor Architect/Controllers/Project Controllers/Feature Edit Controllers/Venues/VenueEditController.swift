//
//  VenueEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/8/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class VenueEditController: PolygonalFeatureEditController, FeatureEditControllerDelegate {
	
	/// A reference to the venue that is being edited
	var venue: Venue!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		super.prepareForFeature(with: venue.id, type: .venue, information: venue.properties.information, from: self)
		super.coordinates = venue.getCoordinates()
		
		//
		// Prepare PolygonFeatureEditController
		setGeometryEdges(count: venue.getCoordinates().count)
		
		title = "Edit Venue"
		
	}
	
	func willCloseEditController() -> Void {
		venue.set(comment: commentCell.textField.text)
		venue.setCoordinates(super.coordinates)
		
		try? Application.currentProject.imdfArchive.save(.unit)
	}
}
