//
//  ProjectAddressLocaleController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectAddressLocaleController: UITableViewController {
	
	enum DataType {
		case country
		case province
	}
	
	var displayController: ProjectAddressEditController!
	
	let dataType: DataType = .country
	
	var dataset: [(displayTitle: String, code: String)] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = dataType == .country ? Localizable.ProjectExplorer.Project.Address.placeholderCountry : Localizable.ProjectExplorer.Project.Address.placeholderProvince
		
		dataset = []
		
		if dataType == .country {
			Locale.isoRegionCodes.forEach { (isoCountryCode) in
				let countryIdentifier	= NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: isoCountryCode])
				let countryName			= NSLocale(localeIdentifier: Locale.current.identifier).displayName(forKey: NSLocale.Key.identifier, value: countryIdentifier)
				
				dataset.append((displayTitle: countryName ?? "", code: isoCountryCode))
			}
			
			dataset.sort { (first, second) -> Bool in
				return first.displayTitle < second.displayTitle
			}
		} else {
			
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataset.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		
		cell.textLabel?.text = dataset[indexPath.row].displayTitle
		cell.detailTextLabel?.text = dataset[indexPath.row].code
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = (displayTitle: dataset[indexPath.row].displayTitle, code: dataset[indexPath.row].code)
		if dataType == .country {
			displayController.countryData = data
		} else {
			
		}
		
		navigationController?.popViewController(animated: true)
	}
}
