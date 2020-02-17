//
//  ProjectDetailsController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectDetailsController: ScrollViewController {

	var project: IMDFProject! {
		didSet {
			reloadProjectDetails()
		}
	}
	
	let projectTitleInput		= FormInputView(title: nil, label: Localizable.ProjectExplorer.CreateProject.projectTitle)
	let projectDescriptionInput	= FormInputView(title: nil, label: Localizable.ProjectExplorer.CreateProject.projectDescription)
	let projectClientInput		= FormInputView(title: nil, label: Localizable.ProjectExplorer.CreateProject.projectClient)
	
	let editMapButton			= ImageTextButton.make(title: "Edit Indoor Map", color: .systemBlue, image: Icon.map)
	let exportMapButton			= ImageTextButton.make(title: "Export IMDF", color: .systemGray4, image: Icon.download)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configure()
    }
	
	private func configure() -> Void {
		view.backgroundColor = .systemBackground

		let scrollContentInset	= UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
		let mainFormView		= configureMainForm(insets: scrollContentInset, previousSibling: scrollContentView)
		let lastSectionView		= configureMapActions(insets: scrollContentInset, previousSibling: mainFormView)
	
		lastSectionView.bottomAnchor.constraint(lessThanOrEqualTo: scrollContentView.bottomAnchor).isActive = true
	}
	
	private func configureMainForm(insets: UIEdgeInsets, previousSibling: UIView) -> UIView {
		let mainFormView = createSectionView(previousSibling: previousSibling, withInsets: insets)
		
		projectTitleInput.parentController			= self
		projectDescriptionInput.parentController	= self
		projectClientInput.parentController			= self
		
		projectTitleInput.textField.addTarget(self,			action: #selector(didChangeTitle),			for: .editingChanged)
		projectDescriptionInput.textField.addTarget(self,	action: #selector(didChangeDescription),	for: .editingChanged)
		projectClientInput.textField.addTarget(self,		action: #selector(didChangeClient),			for: .editingChanged)
		
		mainFormView.addSubview(projectTitleInput)
		mainFormView.addSubview(projectClientInput)
		mainFormView.addSubview(projectDescriptionInput)
		
		NSLayoutConstraint.activate([
			projectTitleInput.topAnchor.constraint(equalTo:			mainFormView.topAnchor),
			projectTitleInput.leadingAnchor.constraint(equalTo:		mainFormView.leadingAnchor),
			projectTitleInput.trailingAnchor.constraint(equalTo:	projectClientInput.leadingAnchor, constant: -insets.right)
		])
		
		NSLayoutConstraint.activate([
			projectClientInput.topAnchor.constraint(equalTo:		mainFormView.topAnchor),
			projectClientInput.trailingAnchor.constraint(equalTo:	mainFormView.trailingAnchor),
			projectClientInput.widthAnchor.constraint(equalTo:		projectTitleInput.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			projectDescriptionInput.topAnchor.constraint(equalTo:		projectTitleInput.bottomAnchor, constant: insets.top),
			projectDescriptionInput.leadingAnchor.constraint(equalTo:	mainFormView.leadingAnchor),
			projectDescriptionInput.trailingAnchor.constraint(equalTo:	mainFormView.trailingAnchor),
			projectDescriptionInput.bottomAnchor.constraint(equalTo:	mainFormView.bottomAnchor)
		])
		
		return mainFormView
	}
	
	private func createSectionView(previousSibling: UIView, withInsets insets: UIEdgeInsets) -> UIView {
		let sectionView = UIView()
		sectionView.translatesAutoresizingMaskIntoConstraints = false
		scrollContentView.addSubview(sectionView)
		
		let anchorToPinAtTop = previousSibling == scrollContentView ? scrollContentView.topAnchor : previousSibling.bottomAnchor
		NSLayoutConstraint.activate([
			sectionView.topAnchor.constraint(equalTo: 		anchorToPinAtTop,					constant: insets.top * 2),
			sectionView.trailingAnchor.constraint(equalTo:	scrollContentView.trailingAnchor,	constant: -insets.right),
			sectionView.leadingAnchor.constraint(equalTo:	scrollContentView.leadingAnchor,	constant: insets.left)
		])
		
		return sectionView
	}
	
	private func configureMapActions(insets: UIEdgeInsets, previousSibling: UIView) -> UIView {
		let mapActionsView = createSectionView(previousSibling: previousSibling, withInsets: insets)
		
		editMapButton.addTarget(self,	action: #selector(didTapEditMap),	for: .touchUpInside)
		exportMapButton.addTarget(self,	action: #selector(didTapExportMap),	for: .touchUpInside)
		
		mapActionsView.addSubview(editMapButton)
		mapActionsView.addSubview(exportMapButton)
		
		mapActionsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
		
		NSLayoutConstraint.activate([
			editMapButton.topAnchor.constraint(equalTo:			mapActionsView.topAnchor),
			editMapButton.trailingAnchor.constraint(equalTo:	exportMapButton.leadingAnchor, constant: -insets.right),
			editMapButton.bottomAnchor.constraint(equalTo:		mapActionsView.bottomAnchor),
			editMapButton.leadingAnchor.constraint(equalTo:		mapActionsView.leadingAnchor),
		])

		NSLayoutConstraint.activate([
			exportMapButton.topAnchor.constraint(equalTo:		mapActionsView.topAnchor),
			exportMapButton.trailingAnchor.constraint(equalTo:	mapActionsView.trailingAnchor),
			exportMapButton.bottomAnchor.constraint(equalTo:	mapActionsView.bottomAnchor),
			exportMapButton.widthAnchor.constraint(equalTo:		editMapButton.widthAnchor)
		])
	
		return mapActionsView
	}
	
	/// Enables the save button in the navigation bar so the changes can be stored
	private func projectDetailsDidChange() -> Void {
		navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject)), animated: true)
	}
	
	@objc func didTapEditMap() -> Void {
		let mapCanvasViewController = MapCanvasViewController()
		mapCanvasViewController.modalPresentationStyle = .fullScreen
		Application.rootViewController.present(mapCanvasViewController, animated: true, completion: nil)
	}
	
	@objc func didTapExportMap() -> Void {
		print("tap export")
	}
	
	@objc func didChangeTitle(_ sender: UITextField) -> Void {
		guard let title = sender.text, title.count > 0 else {
			return
		}
		
		project.manifest.title = title
		project.setUpdated()
		projectDetailsDidChange()
	}
	
	@objc func didChangeDescription(_ sender: UITextField) -> Void {
		project.manifest.description = sender.text
		project.setUpdated()
		projectDetailsDidChange()
	}
	
	@objc func didChangeClient(_ sender: UITextField) -> Void {
		project.manifest.client = sender.text
		project.setUpdated()
		projectDetailsDidChange()
	}
	
	/// Tries to save the project and disables the save button
	/// - Parameter sender: The button which was tapped
	@objc func saveProject(_ sender: UIBarButtonItem) -> Void {
		do {
			try project.save()
			navigationItem.setRightBarButton(nil, animated: true)
			ProjectExplorerHandler.shared.reloadData()
		} catch {
			print(error)
		}
	}
	
	/// Reloads the data from the passed project instance
	private func reloadProjectDetails() -> Void {
		title = project.manifest.title
		projectTitleInput.textField.text		= project.manifest.title
		projectDescriptionInput.textField.text	= project.manifest.description
		projectClientInput.textField.text		= project.manifest.client
	}
}
