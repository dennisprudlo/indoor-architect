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
	
	func getCurrentlyDisplayedProject() -> IMDFProject? {
		guard self.viewControllers.count > 1 else {
			return nil
		}
		
		guard let navigationController = self.viewControllers[1] as? UINavigationController, navigationController.viewControllers.count > 0 else {
			return nil
		}
		
		guard let projectController = navigationController.viewControllers.first as? ProjectController else {
			return nil
		}
		
		return projectController.project
	}
}
