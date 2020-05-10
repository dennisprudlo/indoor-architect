//
//  FeatureEditController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/2/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

protocol FeatureEditControllerDelegate {
	
	/// Tells the delegate, that the user confirmed he wants to delete the currently editing feature. Perform deleting here.
	func didConfirmDeleteFeature() -> Void
	
	/// Tells the delegate, that the feature controller is about to be dismissed. Perform saving here.
	func willCloseEditController() -> Void
}

class FeatureEditController: IATableViewController {
	
	/// A reference to the map canvas if the edit controller was opened inside a map canvas
	var canvas: MCMapCanvas?

	/// The cell which displays the feature id
	let featureIdCell		= UITableViewCell(style: .default, reuseIdentifier: nil)
	
	/// The cell which contains the textField to edit the feature comment
	let commentCell			= TextInputTableViewCell(placeholder: Localizable.Feature.comment)
	
	/// A reference to the specific feature edit controller
	var featureController: FeatureEditControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//
		// Use large titles when editing a feature
		navigationController?.navigationBar.prefersLargeTitles = true
		
		//
		// Add the delete feature and close controller buttons
		navigationItem.leftBarButtonItem	= UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeEditController(_:)))
		navigationItem.rightBarButtonItem	= UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapRemoveFeature(_:)))
		
		//
		// Adjust the table view cells row height to the content
		tableView.rowHeight = UITableView.automaticDimension
		
		//
		// Format the feature id cell
		featureIdCell.selectionStyle		= .none
		featureIdCell.textLabel?.isEnabled	= false
		featureIdCell.textLabel?.font		= featureIdCell.textLabel?.font.monospaced()
		
		//
		// Append the feature id cell
		tableViewSections.append((
			title: "Feature ID",
			description: nil,
			cells: [featureIdCell]
		))
		
		//
		// Append further information meta data cells
		tableViewSections.append((
			title: nil,
			description: nil,
			cells: [commentCell]
		))
    }
	
	/// Prepares the feature edit controller for the feature
	/// - Parameters:
	///   - id: The id of the feature to display
	///   - information: The information meta data set to display
	///   - featureController: The reference to the specific feature controller for event propagation
	func prepareForFeature(with id: UUID, information: IMDFType.EntityInformation?, from featureController: FeatureEditControllerDelegate) -> Void {
		self.featureController			= featureController
		featureIdCell.textLabel?.text	= id.uuidString
		commentCell.textField.text		= information?.comment
	}
	
	/// Triggers the willCloseEditController event for the specific feature edit controller to perform saving
	/// and dismisses the controller afterwards
	/// - Parameter barButtonItem: The barButtonItem that was tapped to trigger the event
	@objc func closeEditController(_ barButtonItem: UIBarButtonItem) -> Void {
		featureController?.willCloseEditController()
		canvas?.renderFeatures()
		dismiss(animated: true, completion: nil)
	}
	
	/// Shows a confirmation dialog whether the user really wants to remove the feature from the project
	/// - Parameter barButtonItem: The barButtonItem that was tapped to trigger the event
	@objc func didTapRemoveFeature(_ barButtonItem: UIBarButtonItem) -> Void {
		let confirmationController = UIAlertController(title: Localizable.General.actionConfirmation, message: Localizable.Feature.removeAlertDescription, preferredStyle: .alert)
		confirmationController.addAction(UIAlertAction(title: Localizable.General.remove, style: .destructive, handler: { (action) in
			
			//
			// Triggers the event that performs deleting of the feature
			self.featureController?.didConfirmDeleteFeature()
			
			//
			// If the canvas property is set and the edit controller was opened in a canvas session
			// The overlays should be regenerated
			self.canvas?.renderFeatures()
			
			//
			// Dismiss the controller after the feature was deleted
			self.dismiss(animated: true, completion: nil)
		}))
		
		confirmationController.addAction(UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: nil))
		
		//
		// Present the confirmation controller
		present(confirmationController, animated: true, completion: nil)
	}
}
