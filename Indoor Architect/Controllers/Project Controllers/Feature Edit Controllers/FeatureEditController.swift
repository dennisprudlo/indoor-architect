//
//  FeatureEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol PromisesFeatureDeleteHandler {
	func delete() -> Void
}

class FeatureEditController: DetailTableViewController {

	typealias TableViewSection = (title: String?, description: String?, cells: [UITableViewCell])
	
	var canvas: MCMapCanvas?
	
	var tableViewSections: [TableViewSection] = []
	
	let featureIdCell		= UITableViewCell(style: .default, reuseIdentifier: nil)
	let commentCell			= TextInputTableViewCell(placeholder: Localizable.Feature.comment)
	
	let saveChangesButton	= ButtonTableViewCell(title: Localizable.Feature.editSaveChanges)
	
	var	information: IMDFType.EntityInformation?
	var featureId: UUID?
	
	var deleteHandlerDelegate: PromisesFeatureDeleteHandler?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeEditController(_:)))
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapRemoveFeature(_:)))
		]
		
		navigationController?.navigationBar.prefersLargeTitles = true
		
		tableView.rowHeight = UITableView.automaticDimension
		
		featureIdCell.selectionStyle		= .none
		featureIdCell.textLabel?.isEnabled	= false
		
		commentCell.textField.addTarget(self, action: #selector(didChangeComment), for: .editingChanged)

		saveChangesButton.setEnabled(false)
		saveChangesButton.cellButton.addTarget(self, action: #selector(didTapSaveChanges), for: .touchUpInside)
		
		tableViewSections.append((
			title: "Feature ID",
			description: nil,
			cells: [featureIdCell]
		))
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: [commentCell]
		))
    }
	
	func propagateFeature<T: Feature<Properties>, Properties: Codable>(_ feature: T, of type: Properties.Type, information: IMDFType.EntityInformation?) -> Void {
		self.information	= information
		self.featureId		= feature.id
		
		featureIdCell.textLabel?.text	= feature.id.uuidString
		commentCell.textField.text		= information?.comment
	}
	
	func notifiyChangesMade() -> Void {
		let commentFieldText	= commentCell.textField.text ?? ""
		let commentFeatureText	= information?.comment ?? ""
		
		saveChangesButton.setEnabled(false)
		saveChangesButton.setEnabled(commentFieldText != commentFeatureText)
	}
	
	@objc func closeEditController(_ barButtonItem: UIBarButtonItem) -> Void {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func didTapRemoveFeature(_ barButtonItem: UIBarButtonItem) -> Void {
		let confirmationController = UIAlertController(title: Localizable.General.actionConfirmation, message: Localizable.Feature.removeAlertDescription, preferredStyle: .alert)
		confirmationController.addAction(UIAlertAction(title: Localizable.General.remove, style: .destructive, handler: { (action) in
			self.deleteHandlerDelegate?.delete()
			self.canvas?.generateIMDFOverlays()
			self.dismiss(animated: true, completion: nil)
		}))
		confirmationController.addAction(UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: nil))
		present(confirmationController, animated: true, completion: nil)
	}
	
	@objc func didChangeComment(_ textField: UITextField) -> Void {
		notifiyChangesMade()
	}
	
	@objc func didTapSaveChanges(_ button: UIButton) -> Void {
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return tableViewSections.count + 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == tableViewSections.count {
			return 1
		}
		
		return tableViewSections[section].cells.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == tableViewSections.count {
			return saveChangesButton
		}
		
		let cell = tableViewSections[indexPath.section].cells[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == tableViewSections.count { return nil }
		return tableViewSections[section].title
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == tableViewSections.count { return nil }
		return tableViewSections[section].description
	}
}
