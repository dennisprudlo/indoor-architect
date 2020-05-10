//
//  IATableViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class IATableViewController: UITableViewController {

	typealias TableViewSection = (title: String?, description: String?, cells: [UITableViewCell])
	
	var tableViewSections: [TableViewSection] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.cellLayoutMarginsFollowReadableWidth	= true
		tableView.separatorStyle						= .none
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return tableViewSections.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableViewSections[section].cells.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableViewSections[indexPath.section].cells[indexPath.row]
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return tableViewSections[section].title
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return tableViewSections[section].description
	}
}
