//
//  AboutSettingsMapController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/8/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class AboutSettingsMapController: IATableViewController {
	
	let pointsOfInteres: [MKPointOfInterestCategory] = [
		.airport, .amusementPark, .aquarium, .atm, .bakery, .bank, .beach, .brewery, .cafe, .campground, .carRental, .evCharger, .fireStation, .fitnessCenter, .foodMarket, .gasStation, .hospital, .hotel,
		.laundry, .library, .marina, .movieTheater, .museum, .nationalPark, .nightlife, .park, .parking, .pharmacy, .police, .postOffice, .publicTransport, .restaurant, .restroom, .school, .stadium, .store,
		.theater, .university, .winery,.zoo
	]
	
	override func viewDidLoad() {
		
		title = Localizable.About.Settings.mapCanvas
		tableView.cellLayoutMarginsFollowReadableWidth = true
	
		var categoryCells: [UITableViewCell] = []
		
		pointsOfInteres.forEach { (category) in
			let cell				= UITableViewCell(style: .default, reuseIdentifier: nil)
			cell.textLabel?.text	= "\(category.rawValue)"
			categoryCells.append(cell)
		}
		
		appendSection(cells: categoryCells)
	}
	
}
