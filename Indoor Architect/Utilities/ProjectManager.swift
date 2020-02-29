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
	let projectsDirectory: URL
	
	/// The extension for a regular Indoor Mapper project
	let projectExtension: String = "imdfproj"
	
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
		case unassignedEntities
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
	
	/// Returns the file `URL` for a given component of the project
	/// - Parameters:
	///   - component: The component to get the `URL` for
	///   - uuid: The `UUID` of the project
	func url(forPathComponent component: ProjectComponent, inProjectWithUuid uuid: UUID) -> URL {
		let directory = projectsDirectory.appendingPathComponent([uuid.uuidString, projectExtension].joined(separator: "."), isDirectory: true)
		
		switch component {
			case .rootDirectory:
				return directory
			case .manifest:
				return directory.appendingPathComponent("manifest").appendingPathExtension("json")
			case .unassignedEntities:
				return directory.appendingPathComponent("unassigned").appendingPathExtension("geojson")
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
	func create(projectWith uuid: UUID, title: String) throws -> IMDFProject {
		try FileManager.default.createDirectory(at: url(forPathComponent: .rootDirectory, inProjectWithUuid: uuid), withIntermediateDirectories: true, attributes: nil)
		try FileManager.default.createDirectory(at: url(forPathComponent: .overlayDirectory, inProjectWithUuid: uuid), withIntermediateDirectories: true, attributes: nil)
		try FileManager.default.createDirectory(at: url(forPathComponent: .archiveDirectory, inProjectWithUuid: uuid), withIntermediateDirectories: true, attributes: nil)
		
		//
		// Create the manifest file for the IMDF Project
		let projectManifestUrl = url(forPathComponent: .manifest, inProjectWithUuid: uuid)
		FileManager.default.createFile(atPath: projectManifestUrl.path, contents: nil, attributes: nil)
	
		let cleanManifest = Manifest(
			version: Application.imdfVersion,
			created: DateUtils.iso8601(for: Date()),
			language: Application.localeLanguageTag,
			generatedBy: Application.versionIdentifier,
			extensions: nil
		)
		
		//
		// Create the archives manifest data representation
		let manifestData = try cleanManifest.data()
		
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
		
		let projectManifest = IMDFProjectManifest(newWithUuid: uuid, title: title)
		return try IMDFProject(existingWith: projectManifest)
	}
	
	/// Returns an array of `UUID` instances that are used for available projects
	func getAvailableProjectUuids() -> [UUID] {
		guard let contents = try? FileManager.default.contentsOfDirectory(atPath: projectsDirectory.path) else {
			return []
		}
		
		var uuids: [UUID] = []
		contents.forEach { (folder) in
			let folderExtension = ".\(projectExtension)"
			if !folder.hasSuffix(folderExtension) {
				return
			}
			
			let uuidString = String(folder.dropLast(folderExtension.count))
			if let uuid = UUID(uuidString: uuidString) {
				uuids.append(uuid)
			}
		}
		
		return uuids
	}
	
	/// Returns a `UUID` which is not used for an existing project
	func getUnusedUuid() -> UUID {
		var unusedUuid: UUID
		repeat {
			unusedUuid = UUID()
		} while exists(withUuid: unusedUuid)
		
		return unusedUuid
	}
	
	/// Returns an `IMDFProject` identified by the given uuid or nil if the project could not be initialized
	/// - Parameter uuid: The `UUID` of the project
	func get(withUuid uuid: UUID) -> IMDFProject? {
		if !exists(withUuid: uuid) {
			return nil
		}
		
		//
		// Load the project manifest data
		let manifestUrl = url(forPathComponent: .manifest, inProjectWithUuid: uuid)
		guard let contents = FileManager.default.contents(atPath: manifestUrl.path) else {
			return nil
		}
		
		guard let manifest = try? JSONDecoder().decode(IMDFProjectManifest.self, from: contents) else {
			return nil
		}
		
		return try? IMDFProject(existingWith: manifest)
	}
	
	/// Returns an array of `IMDFProjects` that could be initialized
	func getAll() -> [IMDFProject] {
		var projects: [IMDFProject] = []
		
		getAvailableProjectUuids().forEach { (uuid) in
			if let project = get(withUuid: uuid) {
				projects.append(project)
			}
		}
		
		return projects
	}
}
