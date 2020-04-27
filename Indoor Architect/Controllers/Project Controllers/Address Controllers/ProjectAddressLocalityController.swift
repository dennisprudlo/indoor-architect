//
//  ProjectAddressLocalityController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectAddressLocalityController: UITableViewController {
	
	enum DataType {
		case country
		case province
	}
	
	/// A reference to the controller that is displaying the selection
	var displayController: ProjectAddressEditController!
	
	/// The data type of the locality selector
	var dataType: DataType = .country
	
	/// A preselected country code. This is important when selecting a subdivision
	var preselectedCountry: String?
	
	/// The dataset of countries and subdivision to display
	var dataset: [[ISO3166.CodeCombination]] = []
	
	/// A list of existing addresses to determine already used countries and subdivisions
	var existingAddresses: [Address] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = dataType == .country ? Localizable.Project.Address.placeholderCountry : Localizable.Project.Address.placeholderProvince
		
		if !displayController.shouldRenderToCreate {
			tableView.cellLayoutMarginsFollowReadableWidth	= true
			tableView.backgroundColor						= Color.lightStyleTableViewBackground
			tableView.separatorColor						= Color.lightStyleCellSeparatorColor
		}
		
		//
		// Constructing the dataset which will be displayed
		dataset = []
		
		if dataType == .country {
			
			//
			// If a list of countries is being displayed we show previously used countries in a distinct section first
			var previouslyUsedCountries: [ISO3166.CodeCombination] = []
			existingAddresses.forEach { (address) in
				
				//
				// If the country data can be extracted and there is no country in the list yet we want to add it to the list
				guard let countryData = address.getCountryData(), !previouslyUsedCountries.contains(where: { $0.code == countryData.code }) else {
					return
				}
				
				previouslyUsedCountries.append(countryData)
			}
			
			//
			// If there are any previously used countries we sort them by name and append them to the dataset
			if previouslyUsedCountries.count > 0 {
				previouslyUsedCountries.sort(by: { $0.title < $1.title })
				dataset.append(previouslyUsedCountries)
			}
			
			dataset.append(ISO3166.getCountryData())
		} else {
			
			//
			// If a list of subdivisions is being displayed we show previously used subdivisiions in a distinct section first
			var previouslyUsedSubdivisions: [ISO3166.CodeCombination] = []
			existingAddresses.forEach { (address) in

				//
				// We only want to get the subdivisions from the preselected country
				guard let countryData = address.getCountryData(), countryData.code == preselectedCountry ?? "" else {
					return
				}
				
				//
				// If the subdivision data can be extracted and there is no subdivision in the list yet we want to add it to the list
				guard let subdivisionData = address.getSubdivisionData(), !previouslyUsedSubdivisions.contains(where: { $0.code == subdivisionData.code }) else {
					return
				}
				
				previouslyUsedSubdivisions.append(subdivisionData)
			}
			
			//
			// If there are any previously used subdivisions we sort them by name and append them to the dataset
			if previouslyUsedSubdivisions.count > 0 {
				previouslyUsedSubdivisions.sort(by: { $0.title < $1.title })
				dataset.append(previouslyUsedSubdivisions)
			}
			
			dataset.append(ISO3166.getSubdivisionData(for: preselectedCountry ?? ""))
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return dataset.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataset[section].count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		// When there is an additional previously used section and its being processed
		// a localized title should be appended
		if dataset.count > 1 && section == 0 {
			return Localizable.Project.Address.titlePreviouslyUsed
		}
		
		if let countryCode = preselectedCountry {
			return ISO3166.provinceCategory(for: countryCode)
		}
		
		return nil
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		
		//
		// Format the cell
		cell.textLabel?.text = dataset[indexPath.section][indexPath.row].title
		cell.detailTextLabel?.text = dataset[indexPath.section][indexPath.row].code
		cell.detailTextLabel?.font = cell.detailTextLabel?.font.monospaced()
		
		if !displayController.shouldRenderToCreate {
			cell.backgroundColor = Color.lightStyleCellBackground
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = (code: dataset[indexPath.section][indexPath.row].code, title: dataset[indexPath.section][indexPath.row].title)
		
		if dataType == .country {
			displayController.countryData = data
		} else {
			displayController.provinceData = data
		}
		
		navigationController?.popViewController(animated: true)
	}
}
