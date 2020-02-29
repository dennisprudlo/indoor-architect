//
//  ProjectSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol ProjectSectionDelegate {
	func numberOfRows() -> Int
	func titleForHeader() -> String?
	func titleForFooter() -> String?
	func cellForRow(at index: Int) -> UITableViewCell
	func accessoryButtonTappedForRow(at index: Int) -> Void
	func initialize() -> Void
}

class ProjectSection: ProjectSectionDelegate {

	var cells: [UITableViewCell] = []
	var delegate: ProjectController?
	
	func numberOfRows() -> Int {
		return cells.count
	}
	
	func titleForHeader() -> String? {
		return nil
	}
	
	func titleForFooter() -> String? {
		return nil
	}
	
	func cellForRow(at index: Int) -> UITableViewCell {
		return cells[index]
	}
	
	func accessoryButtonTappedForRow(at index: Int) {
		
	}
	
	func initialize() {
		
	}
}
