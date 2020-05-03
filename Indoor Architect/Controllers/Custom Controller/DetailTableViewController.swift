//
//  DetailTableViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.cellLayoutMarginsFollowReadableWidth	= true
		tableView.separatorStyle						= .none
    }
}
