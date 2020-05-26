//
//  FeatureLabelsController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol FeatureLabelsControllerDelegate {
	func labelController(_ controller: FeatureLabelsController, didConfigure labels: IMDFType.Labels?) -> Void
}

class FeatureLabelsController: IATableViewController, FeatureLabelsComposeControllerDelegate {

	var labels: IMDFType.Labels? = [
		"de": "Nachbarhaus",
		"en-us": "Neighbor house",
		"en-gb": "Neighbour house"
	]
	
	/// The delegate that handles the selection
	var delegate: FeatureLabelsControllerDelegate?
	
	/// The identifier can be used to identify multiple label maker controller in one context
	var identifier: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeLabel(_:)))
		
		//
		// In this case for better readability we use the separator line between the cells
		tableView.separatorStyle = .singleLine
		
		var labelCells: [UITableViewCell] = []
		
		//
		// Compose the cells for the labels
		labels?.sorted(by: { $0.key < $1.key }).forEach { (identifier, title) in
			let labelCell					= UITableViewCell(style: .value1, reuseIdentifier: nil)
			labelCell.textLabel?.text		= identifier
			labelCell.textLabel?.font		= labelCell.textLabel?.font.monospaced()
			labelCell.detailTextLabel?.text	= title
			labelCell.accessoryType			= .disclosureIndicator

			labelCells.append(labelCell)
		}
		
		reloadEntries()
    }

	func reloadEntries() -> Void {
		if tableViewSections.count == 0 {
			//
			// Add the label cells
			tableViewSections.append((
				title: nil,
				description: nil,
				cells: []
			))
		}
		
		var labelCells: [UITableViewCell] = []
		
		//
		// Compose the cells for the labels
		labels?.sorted(by: { $0.key < $1.key }).forEach { (identifier, title) in
			let labelCell					= UITableViewCell(style: .value1, reuseIdentifier: nil)
			labelCell.textLabel?.text		= identifier
			labelCell.textLabel?.font		= labelCell.textLabel?.font.monospaced()
			labelCell.detailTextLabel?.text	= title
			labelCell.accessoryType			= .disclosureIndicator
			
			labelCells.append(labelCell)
		}
		
		tableViewSections[0].cells = labelCells
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//
		// If the view controller is being dismissed (closed) we want to collect
		// all configures labels and return them
		if isMovingFromParent {
			delegate?.labelController(self, didConfigure: labels?.isEmpty ?? true ? nil : labels)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath), let key = cell.textLabel?.text else {
			return
		}
		
		let labelComposeController			= FeatureLabelsComposeController(style: .insetGrouped)
		labelComposeController.delegate		= self
		labelComposeController.title		= Localizable.Feature.editLabel
		labelComposeController.editWithKey	= key
		labelComposeController.languageIdentifierCell.setText(key)
		labelComposeController.labelCell.setText(cell.detailTextLabel?.text)
		navigationController?.pushViewController(labelComposeController, animated: true)
	}
	
	@objc func didTapComposeLabel(_ barButtonItem: UIBarButtonItem) -> Void {
		let labelComposeController		= FeatureLabelsComposeController(style: .insetGrouped)
		labelComposeController.delegate	= self
		labelComposeController.title	= Localizable.Feature.newLabel
		navigationController?.pushViewController(labelComposeController, animated: true)
	}
	
	func labelComposeController(_ controller: FeatureLabelsComposeController, didEditLabelWith key: String, newIdentifier: String, and label: String) {

		//
		// If the new language identifier is empty abort
		// An empty identifier is not valid
		guard !newIdentifier.isEmpty else {
			return
		}

		//
		// If the labels set is not set assign an empty dictionary to proceed
		if labels == nil {
			labels = [:]
		}
		
		//
		// If the key of the edited label exists in the set remove the entry
		// We will set a new entry with the newIdentifier (which may be the same)
		labels?.forEach({ (label) in
			// Ignore case (en-US is the same as en-us)
			let lower = label.key.lowercased()
			if lower == key.lowercased() || lower == newIdentifier.lowercased(), let index = labels?.index(forKey: label.key) {
				labels?.remove(at: index)
			}
		})

		//
		// Set the newIdentifier and label combination
		labels?[newIdentifier] = label

		//
		// Reload the data and the table view
		reloadEntries()
		tableView.reloadData()
	}
	
	func labelComposeController(_ controller: FeatureLabelsComposeController, didTapRemoveLabelWith key: String) {
	
		//
		// Remove all entries with the given key
		labels?.forEach({ (label) in
			// Ignore case (en-US is the same as en-us)
			if label.key.lowercased() == key.lowercased(), let index = labels?.index(forKey: key) {
				labels?.remove(at: index)
			}
		})
		
		//
		// Reload the data and the table view
		reloadEntries()
		tableView.reloadData()
		
		controller.navigationController?.popViewController(animated: true)
	}
}
