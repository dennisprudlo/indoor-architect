//
//  ProjectManager.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class ProjectManager {
	
	/// The shared project manager accessible throughout the application
	static let shared = ProjectManager()
	
	/// The url to the applications project directory
	private let projectsDirectory: URL
	
	/// The extension for a regular Indoor Mapper project
	private let projectExtension: String = "imdfproj"
	
	/// Initializes the `ProjectManager` shared instance
	///
	/// Since the project manager is shared throughout the application it cannot be instanciated outside its own class-scope.
	/// Use the static `shared` property instead.
	init() {
		let documentDirectory	= try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let projectsDirectory	= documentDirectory?.appendingPathComponent("Projects", isDirectory: true)
		
		//
		// Assign the projects directory url
		self.projectsDirectory = URL(fileURLWithPath: projectsDirectory?.path ?? "", isDirectory: true)
	}
	
	/// Checks whether a project with the given UUID already exists
	/// - Parameter uuid: The UUID to check for
	func exists(withUuid uuid: UUID) -> Bool {
		let projectUrl = projectsDirectory.appendingPathComponent([uuid.uuidString, projectExtension].joined(separator: "."), isDirectory: true)
		return FileManager.default.fileExists(atPath: projectUrl.path)
	}
	
	/// Removes a project completely for the device
	/// - Parameter uuid: The UUID of the project to delete
	///
	/// - Important: The project will be deleted from the device for good.
	func delete(withUuid uuid: UUID) throws -> Void {
		let projectUrl = projectsDirectory.appendingPathComponent([uuid.uuidString, projectExtension].joined(separator: "."), isDirectory: true)
		try FileManager.default.removeItem(at: projectUrl)
	}
	
	/// Creates the folder and file structure for an empty project
	/// - Parameter uuid: The uuid to use for that project
	///
	/// This function only creates the necessary folders and files that are needed to sucessfully initialize an
	/// instance of the type `IMDFProject`. Right after the structure was created the `IMDFProject` should
	/// write its data into the files using the `save`-Method of the `IMDFProject`
	func create(structurForProjectWithUuid uuid: UUID) throws -> Void {
		
	}
}
