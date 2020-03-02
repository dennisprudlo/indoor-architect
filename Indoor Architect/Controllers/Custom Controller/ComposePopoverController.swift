//
//  ComposePopoverController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ComposePopoverController: UITableViewController {
	
	typealias TableViewSection = (title: String?, description: String?, cells: [UITableViewCell])
	
	var tableViewSections: [TableViewSection] = []
	
	let confirmButtonCell = ButtonTableViewCell(title: "Add")
	
	var confirmButtonTitle: String? {
		didSet {
			confirmButtonCell.cellButton.setTitle(self.confirmButtonTitle, for: .normal)
		}
	}
	
	var isConfirmButtonEnabled: Bool = true {
		didSet {
			self.confirmButtonCell.setEnabled(self.isConfirmButtonEnabled)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//
		// Add the cancel bar button item
		navigationItem.leftBarButtonItem	= UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
		
		//
		// Configure create button
		confirmButtonCell.cellButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		tableView.removeObserver(self, forKeyPath: "contentSize")
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		self.preferredContentSize = tableView.contentSize
	}
	
	@objc func didTapCancel(_ barButtonItem: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func didTapCreate(_ sender: UIButton) -> Void {
		
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
