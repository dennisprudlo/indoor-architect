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
	
	let projectTitleInput		= FormInputView(title: nil, description: Localizable.ProjectExplorer.CreateProject.projectTitle)
	let projectDescriptionInput	= FormInputView(title: nil, description: Localizable.ProjectExplorer.CreateProject.projectDescription)
	let projectClientInput		= FormInputView(title: nil, description: Localizable.ProjectExplorer.CreateProject.projectClient)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configure()
    }
	
	private func configure() -> Void {
		view.backgroundColor = .systemBackground
		
		var previousInput: FormInputView? = nil
		for input in [projectTitleInput, projectDescriptionInput, projectClientInput] {
			scrollContentView.addSubview(input)
			
			if let previous = previousInput {
				input.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 16).isActive = true
			} else {
				input.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
			}
			
			input.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
			input.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16).isActive = true
			
			previousInput = input
		}
		
		previousInput!.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
		
		projectTitleInput.textField.addTarget(self, action: #selector(didChangeTitle), for: .editingChanged)
		projectDescriptionInput.textField.addTarget(self, action: #selector(didChangeDescription), for: .editingChanged)
		projectClientInput.textField.addTarget(self, action: #selector(didChangeClient), for: .editingChanged)
	}
	
	/// Enables the save button in the navigation bar so the changes can be stored
	private func projectDetailsDidChange() -> Void {
		navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject)), animated: true)
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
