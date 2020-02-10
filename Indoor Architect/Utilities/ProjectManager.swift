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
	
	enum ArchiveFeature: CaseIterable {
		/// The feature collection for the address component
		case address
		
		/// The feature collection for the amenity component
		case amenity
		
		/// The feature collection for the anchor component
		case anchor
		
		/// The feature collection for the building component
		case building
		
		/// The feature collection for the detail component
		case detail
		
		/// The feature collection for the fixture component
		case fixture
		
		/// The feature collection for the footprint component
		case footprint
		
		/// The feature collection for the geofence component
		case geofence
		
		/// The feature collection for the kiosk component
		case kiosk
		
		/// The feature collection for the level component
		case level
		
		/// The archives manifest file
		case manifest
		
		/// The feature collection for the occupant component
		case occupant
		
		/// The feature collection for the opening component
		case opening
		
		/// The feature collection for the relationship component
		case relationship
		
		/// The feature collection for the section component
		case section
		
		/// The feature collection for the unit component
		case unit
		
		/// The feature collection for the venue component
		case venue
	}
	
	enum ProjectComponent {
		case rootDirectory
		case manifest
		case overlayDirectory
		case overlay(uuid: UUID)
		case archiveDirectory
		case archive(feature: ArchiveFeature)
	}
	
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
	
	func url(forPathComponent component: ProjectComponent, inProjectWithUuid uuid: UUID) -> URL {
		let directory = projectsDirectory.appendingPathComponent([uuid.uuidString, projectExtension].joined(separator: "."), isDirectory: true)
		
		switch component {
			case .rootDirectory:
				return directory
			case .manifest:
				return directory.appendingPathComponent("manifest").appendingPathExtension("json")
			case .overlayDirectory:
				return directory.appendingPathComponent("overlays", isDirectory: true)
			case .overlay(let uuid):
				return url(forPathComponent: .overlayDirectory, inProjectWithUuid: uuid).appendingPathComponent("\(uuid.uuidString).overlay", isDirectory: true)
			case .archiveDirectory:
				return directory.appendingPathComponent("archive.imdf", isDirectory: true)
			case .archive(let feature):
				if feature == .manifest {
					return url(forPathComponent: .archiveDirectory, inProjectWithUuid: uuid)
					.appendingPathComponent("manifest")
					.appendingPathExtension("json")
				} else {
					return url(forPathComponent: .archiveDirectory, inProjectWithUuid: uuid)
					.appendingPathComponent("\(feature)")
					.appendingPathExtension("geojson")
				}
		}
	}
	
	/// Creates the folder and file structure for an empty project
	/// - Parameter uuid: The uuid to use for that project
	///
	/// This function only creates the necessary folders and files that are needed to sucessfully initialize an
	/// instance of the type `IMDFProject`. Right after the structure was created the `IMDFProject` should
	/// write its data into the files using the `save`-Method of the `IMDFProject`
	func create(structurForProjectWithUuid uuid: UUID) throws -> Void {
		try FileManager.default.createDirectory(at: url(forPathComponent: .rootDirectory, inProjectWithUuid: uuid), withIntermediateDirectories: true, attributes: nil)
		try FileManager.default.createDirectory(at: url(forPathComponent: .overlayDirectory, inProjectWithUuid: uuid), withIntermediateDirectories: true, attributes: nil)
		try FileManager.default.createDirectory(at: url(forPathComponent: .archiveDirectory, inProjectWithUuid: uuid), withIntermediateDirectories: true, attributes: nil)
		
		//
		// Create the manifest file for the IMDF Project
		FileManager.default.createFile(atPath: url(forPathComponent: .manifest, inProjectWithUuid: uuid).path, contents: nil, attributes: nil)
	
		//
		// Create the archives manifest data representation
		let manifestData = try JSONSerialization.data(withJSONObject: [
			"version":		Application.imdfVersion,
			"created":		DateUtils.iso8601(for: Date()),
			"generated_by":	nil,
			"language":		nil,
			"extensions":	nil
		], options: .prettyPrinted)
		
		//
		// Create all file in the IMDF archive with a blueprint content
		for feature in ArchiveFeature.allCases {
			let data = feature == .manifest ? manifestData : try JSONSerialization.data(withJSONObject: [
				"type":		"FeatureCollection",
				"name":		"\(feature)",
				"features":	[],
			], options: .prettyPrinted)
			
			FileManager.default.createFile(atPath: url(forPathComponent: .archive(feature: feature), inProjectWithUuid: uuid).path, contents: data, attributes: nil)
		}
		
		print(url(forPathComponent: .rootDirectory, inProjectWithUuid: uuid).path)
	}
}
