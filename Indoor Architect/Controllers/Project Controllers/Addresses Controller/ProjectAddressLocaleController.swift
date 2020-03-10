//
//  ProjectAddressLocaleController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/1/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectAddressLocaleController: DetailTableViewController {
	
	enum DataType {
		case country
		case province
	}
	
	var displayController: ProjectAddressEditController!
	
	var dataType: DataType = .country
	var preselectedCountry: String?
	
	var dataset: [Address.LocalityCodeCombination] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = dataType == .country ? Localizable.ProjectExplorer.Project.Address.placeholderCountry : Localizable.ProjectExplorer.Project.Address.placeholderProvince
		
		dataset = []
		if dataType == .country {
			dataset = Address.getLocalizedCountryCodes()
		} else {
			dataset = Address.getSubdivisions(forCountry: preselectedCountry ?? "")
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
		
		cell.textLabel?.text = dataset[indexPath.row].title
		cell.detailTextLabel?.text = dataset[indexPath.row].code
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = (code: dataset[indexPath.row].code, title: dataset[indexPath.row].title)
		
		if dataType == .country {
			displayController.countryData = data
		} else {
			displayController.provinceData = data
		}
		
		navigationController?.popViewController(animated: true)
	}
}
