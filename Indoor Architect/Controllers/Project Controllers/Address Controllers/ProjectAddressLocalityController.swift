//
//  ProjectAddressLocalityController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol ProjectAddressLocalityControllerDelegate {
	func addressLocalityPicker(_ picker: ProjectAddressLocalityController, didPickDataOfType dataType: ProjectAddressLocalityController.DataType, data: ISO3166.CodeCombination) -> Void
}

class ProjectAddressLocalityController: DetailTableViewController, UISearchBarDelegate {
	
	enum DataType {
		case country
		case province
	}
	
	var delegate: ProjectAddressLocalityControllerDelegate?
	
	/// The data type of the locality selector
	var dataType: DataType = .country
	
	/// Whether to include a search bar
	var showSearchBar: Bool = false
	
	/// A preselected country code. This is important when selecting a subdivision
	var preselectedCountry: String?
	
	/// A list of existing addresses to determine already used countries and subdivisions
	var existingAddresses: [Address] = []
	
	/// The dataset of countries and subdivision
	private var dataset: [[ISO3166.CodeCombination]] = []
	
	/// The dataset of countries and subdivisions which is currently displayed
	private var displayedDataset: [[ISO3166.CodeCombination]] = []
	
	/// A reference to the search bar appearing when creating a new address
	private let projectSearchController = UISearchController(searchResultsController: nil)
	
	init(dataType: DataType) {
		super.init(style: .insetGrouped)
		self.dataType = dataType
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = dataType == .country ? Localizable.Address.placeholderCountry : Localizable.Address.placeholderProvince
		
		if showSearchBar {
			//
			// Configure search controller and search bar
			projectSearchController.obscuresBackgroundDuringPresentation	= false
			projectSearchController.hidesNavigationBarDuringPresentation	= false
			projectSearchController.searchBar.placeholder					= Localizable.Address.localitySearchBarPlaceholder
			projectSearchController.searchBar.delegate						= self
			navigationItem.searchController									= projectSearchController
			navigationItem.hidesSearchBarWhenScrolling						= false
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
		
		searchBar(projectSearchController.searchBar, textDidChange: "")
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		displayedDataset = dataset

		if searchText.count > 0 {
			
			let query = searchText.lowercased()
			let filtered = dataset[dataset.count - 1].filter({
				query.contains($0.code.lowercased()) || query.contains($0.title.lowercased()) || $0.title.lowercased().contains(query) || $0.code.lowercased().contains(query)
			})
			
			displayedDataset[displayedDataset.count - 1] = filtered
		}
		
		tableView.reloadData()
	}
	
	/// Returns a code combination for an item at an specific index path
	/// - Parameter indexPath: The index path of the cell to get the code combination from
	/// - Returns: An `ISO3166.CodeCombination`
	func codeCombination(at indexPath: IndexPath) -> ISO3166.CodeCombination {
		let code	= displayedDataset[indexPath.section][indexPath.row].code
		let title	= displayedDataset[indexPath.section][indexPath.row].title
		return ISO3166.CodeCombination(code: code, title: title)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return displayedDataset.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayedDataset[section].count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		// When there is an additional previously used section and its being processed
		// a localized title should be appended
		if displayedDataset.count > 1 && section == 0 {
			return Localizable.Address.titlePreviouslyUsed
		}
		
		if let countryCode = preselectedCountry {
			return ISO3166.provinceCategory(for: countryCode)
		}
		
		return nil
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		
		let data = codeCombination(at: indexPath)
		
		//
		// Format the cell
		cell.textLabel?.text		= data.title
		cell.detailTextLabel?.text	= data.code
		cell.detailTextLabel?.font	= cell.detailTextLabel?.font.monospaced()
		
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.addressLocalityPicker(self, didPickDataOfType: dataType, data: codeCombination(at: indexPath))
	}
}
