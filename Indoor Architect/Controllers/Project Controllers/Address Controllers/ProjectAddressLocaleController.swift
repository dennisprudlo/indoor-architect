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
	
	var dataType: DataType = .country
	var preselectedCountry: String?
	
	var dataset: [Address.LocalityCodeCombination] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = dataType == .country ? Localizable.Project.Address.placeholderCountry : Localizable.Project.Address.placeholderProvince
		
		if !displayController.shouldRenderToCreate {
			tableView.cellLayoutMarginsFollowReadableWidth	= true
			tableView.backgroundColor						= Color.lightStyleTableViewBackground
			tableView.separatorColor						= Color.lightStyleCellSeparatorColor
		}
		
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
		
		//
		// Format the cell
		cell.textLabel?.text = dataset[indexPath.row].title
		cell.detailTextLabel?.text = dataset[indexPath.row].code
		cell.detailTextLabel?.font = cell.detailTextLabel?.font.monospaced()
		
		if !displayController.shouldRenderToCreate {
			cell.backgroundColor = Color.lightStyleCellBackground
		}
		
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
