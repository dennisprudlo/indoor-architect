//
//  RootController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class RootController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		preferredDisplayMode = .allVisible
		
		Application.rootController = self
    }
}
