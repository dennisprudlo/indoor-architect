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

		projectTitleInput.parentController = self
		projectDescriptionInput.parentController = self
		projectClientInput.parentController = self
		
		editMapButton.addTarget(self, action: #selector(didTapEditMap), for: .touchUpInside)
		exportMapButton.addTarget(self, action: #selector(didTapExportMap), for: .touchUpInside)
		
		let scrollContentInset: CGFloat = 16
		scrollContentView.addSubview(projectTitleInput)
		scrollContentView.addSubview(projectClientInput)
		scrollContentView.addSubview(projectDescriptionInput)
		
//		scrollContentView.addSubview(editMapButton)
//		scrollContentView.addSubview(exportMapButton)
		
		NSLayoutConstraint.activate([
			projectTitleInput.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
			projectTitleInput.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: scrollContentInset),
			projectTitleInput.trailingAnchor.constraint(equalTo: projectClientInput.leadingAnchor, constant: -scrollContentInset)
		])
		
		NSLayoutConstraint.activate([
			projectClientInput.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
			projectClientInput.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -scrollContentInset),
			projectClientInput.widthAnchor.constraint(equalTo: projectTitleInput.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			projectDescriptionInput.topAnchor.constraint(equalTo: projectTitleInput.bottomAnchor, constant: scrollContentInset),
			projectDescriptionInput.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: scrollContentInset),
			projectDescriptionInput.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -scrollContentInset)
		])
		
		projectDescriptionInput.bottomAnchor.constraint(lessThanOrEqualTo: scrollContentView.bottomAnchor).isActive = true
		
//		editMapButton.topAnchor.constraint(equalTo: projectTitleInput.textFieldWrapper.topAnchor).isActive = true
//		editMapButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -scrollContentInset).isActive = true
//		editMapButton.bottomAnchor.constraint(equalTo: projectTitleInput.bottomAnchor).isActive = true
//		editMapButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
//
//		projectDescriptionInput.topAnchor.constraint(equalTo: projectTitleInput.bottomAnchor, constant: scrollContentInset).isActive = true
//		projectDescriptionInput.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: scrollContentInset).isActive = true
//		projectDescriptionInput.trailingAnchor.constraint(equalTo: exportMapButton.leadingAnchor, constant: -scrollContentInset).isActive = true
//
//		exportMapButton.topAnchor.constraint(equalTo: projectDescriptionInput.textFieldWrapper.topAnchor).isActive = true
//		exportMapButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -scrollContentInset).isActive = true
//		exportMapButton.bottomAnchor.constraint(equalTo: projectDescriptionInput.bottomAnchor).isActive = true
//		exportMapButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
		
		projectTitleInput.textField.addTarget(self, action: #selector(didChangeTitle), for: .editingChanged)
		projectDescriptionInput.textField.addTarget(self, action: #selector(didChangeDescription), for: .editingChanged)
		projectClientInput.textField.addTarget(self, action: #selector(didChangeClient), for: .editingChanged)
	}
	
	/// Enables the save button in the navigation bar so the changes can be stored
	private func projectDetailsDidChange() -> Void {
		navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject)), animated: true)
	}
	
	@objc func didTapEditMap() -> Void {
		print("tap edit")
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
