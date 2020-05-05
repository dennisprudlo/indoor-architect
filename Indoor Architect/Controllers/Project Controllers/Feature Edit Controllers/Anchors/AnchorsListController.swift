//
//  AnchorsListController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 4/28/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class AnchorsListController: DetailTableViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Anchors"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Application.currentProject.imdfArchive.anchors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

		let anchor					= Application.currentProject.imdfArchive.anchors[indexPath.row]
		cell.textLabel?.text		= anchor.id.uuidString
		cell.detailTextLabel?.text	= "Lat: \(anchor.getCoordinates().latitude), Lng: \(anchor.getCoordinates().longitude)"
		cell.accessoryType			= .disclosureIndicator
		
        return cell
    }
}
