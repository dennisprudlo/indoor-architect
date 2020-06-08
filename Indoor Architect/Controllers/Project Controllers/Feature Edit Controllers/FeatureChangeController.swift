//
//  FeatureChangeController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 6/6/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class FeatureChangeController: IATableViewController {
	
	//
	// Point Features
	let amenityFeature		= LeadingIconTableViewCell(title: "Amenity", icon: Icon.feature)
	let anchorFeature		= LeadingIconTableViewCell(title: "Anchor", icon: Icon.feature)
	
	//
	// Lineal Features
	let detailFeature		= LeadingIconTableViewCell(title: "Detail", icon: Icon.feature)
	let openingFeature		= LeadingIconTableViewCell(title: "Opening", icon: Icon.feature)
	
	//
	// Polygonal Features
	let fixtureFeature		= LeadingIconTableViewCell(title: "Fixture", icon: Icon.feature)
	let footprintFeature	= LeadingIconTableViewCell(title: "Footprint", icon: Icon.feature)
	let geofenceFeature		= LeadingIconTableViewCell(title: "Geofence", icon: Icon.feature)
	let kioskFeature		= LeadingIconTableViewCell(title: "Kiosk", icon: Icon.feature)
	let levelFeature		= LeadingIconTableViewCell(title: "Level", icon: Icon.feature)
	let sectionFeature		= LeadingIconTableViewCell(title: "Section", icon: Icon.feature)
	let unitFeature			= LeadingIconTableViewCell(title: "Unit", icon: Icon.feature)
	let venueFeature		= LeadingIconTableViewCell(title: "Venue", icon: Icon.feature)
	
	enum Category {
		case point
		case lineal
		case polygonal
	}
	
	var canvas: MCMapCanvas?
	
	static var cellSet: [Category: [ProjectManager.ArchiveFeature]] = [
		.point: [.amenity, .anchor],
		.lineal: [.detail, .opening],
		.polygonal: [.fixture, .footprint, .geofence, .kiosk, .level, .section, .unit, .venue]
	]
	
	var category: Category = .polygonal
	
	var currentType: ProjectManager.ArchiveFeature = .unit
	
	var currentUuid: UUID = UUID()
	
	override func viewDidLoad() {
		title = Localizable.Feature.changeFeatureType
		
		//
		// Add the close controller button
		navigationItem.leftBarButtonItem	= UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeController))
		
		let projectHasVenue = Application.currentProject.imdfArchive.venues.count > 0
		
		var cells: [LeadingIconTableViewCell] = []
		FeatureChangeController.cellSet[category]?.forEach({ (type) in
			guard let cell = self.cellFor(type) else {
				return
			}
			
			if projectHasVenue && cell == venueFeature {
				cell.isEnabled = false
				cell.isUserInteractionEnabled = false
				cell.detailTextLabel?.text = Localizable.Feature.venueAlreadyExists
			}
			
			if type == self.currentType {
				cell.isEnabled = false
				cell.isUserInteractionEnabled = false
				cell.detailTextLabel?.text = Localizable.Feature.currentFeatureType
			}
			
			cells.append(cell)
		})

		appendSection(cells: cells, title: "\(category)", description: nil)
	}
	
	static func forFeature(withUuid uuid: UUID, type: ProjectManager.ArchiveFeature, canvas: MCMapCanvas?) -> UINavigationController {
		let changeController						= FeatureChangeController(style: .insetGrouped)
		
		FeatureChangeController.cellSet.forEach { tuple in
			if tuple.value.contains(type) {
				changeController.category = tuple.key
			}
		}
		changeController.currentType	= type
		changeController.currentUuid	= uuid
		changeController.canvas			= canvas
		
		let navigationController					= UINavigationController(rootViewController: changeController)
		navigationController.modalPresentationStyle	= .formSheet
		navigationController.navigationBar.prefersLargeTitles = true
		
		return navigationController
	}
	
	@objc func closeController() -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	func cellFor(_ featureType: ProjectManager.ArchiveFeature) -> LeadingIconTableViewCell? {
		switch featureType {
			case .address:
			return nil
			case .amenity:
			return amenityFeature
			case .anchor:
			return anchorFeature
			case .building:
			return nil
			case .detail:
			return detailFeature
			case .fixture:
			return fixtureFeature
			case .footprint:
			return footprintFeature
			case .geofence:
			return geofenceFeature
			case .kiosk:
			return kioskFeature
			case .level:
			return levelFeature
			case .manifest:
			return nil
			case .occupant:
			return nil
			case .opening:
			return openingFeature
			case .relationship:
			return nil
			case .section:
			return sectionFeature
			case .unit:
			return unitFeature
			case .venue:
			return venueFeature
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? LeadingIconTableViewCell else {
			return
		}
		
		var featureType: ProjectManager.ArchiveFeature?
		ProjectManager.ArchiveFeature.allCases.forEach { (type) in
			if self.cellFor(type) == cell {
				featureType = type
			}
		}
		
		guard let safeFeatureType = featureType else {
			dismiss(animated: true, completion: nil)
			return
		}
		
		let alertController = UIAlertController(title: Localizable.General.actionConfirmation, message: Localizable.Feature.changeFeatureTypeConfirmation, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: Localizable.General.cancel, style: .destructive, handler: nil))
		alertController.addAction(UIAlertAction(title: Localizable.General.yes, style: .default, handler: { (action) in
			
			guard let changeData = Application.currentProject.imdfArchive.getChangeInformation(forFeatureWithUuid: self.currentUuid) else {
				print("geometry could not be retrieved")
				return
			}
			
			Application.currentProject.imdfArchive.removeFeature(with: self.currentUuid)
			Application.currentProject.imdfArchive.createFeature(ofType: safeFeatureType, geometry: changeData.geometry, information: changeData.information, uuid: self.currentUuid)
			
			self.canvas?.renderFeatures()
			self.dismiss(animated: true, completion: nil)
		}))

		present(alertController, animated: true, completion: nil)
	}
}
