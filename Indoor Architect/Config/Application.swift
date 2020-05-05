//
//  Application.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/9/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

struct Application {
	
	/// The application title used all over the app
	static let title		= "Indoor Architect"
	
	/// The applications current version
	static let version		= Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
	
	/// The application current build number
	static let build		= Int(Bundle.main.infoDictionary?["CFBundleVersion"] as! String) ?? 0
	
	/// An application identifier string which contains the name and versioning information
	static let versionIdentifier = "\(title) \(version)b\(build)"
	
	/// The currently used version of the indoor mapping data format
	static let imdfVersion	= "1.0.0.rc.1"
	
	/// A reference to the master view controller which is set after its initialization
	static var masterController: MasterController!
	
	/// A reference to the root view controller which is set after its initialization
	static var rootController: RootController!
	
	/// A reference to the currently selected project
	///
	/// In most cases the `IMDFProject` is used and more rather needed in every view to get at least
	/// a reference to the IMDF Features. One approach would be to pass the reference of the project down
	/// to every controller which ends with every controller having a project reference. When a project is selected
	/// The reference is being assigned to this property and can be used throughout the app.
	///
	/// The project reference may be nil, when no project is selected. This could be when a guide or resource is visible
	/// - Important:
	///	It is very important to make sure that this property always represents the current project selection state.
	/// Therefore the property is an implicitly unwrapped `IMDFProject`. We assume at any given time in a project
	/// context, that this property is set.
	static var currentProject: IMDFProject!
	
	/// Gets a RFC 5646 compliant language tag for the current locale
	///
	/// If for some reason the language tag couldn't be obtained the property falls back to `en-US`
	static var localeLanguageTag: String {
		guard let languageCode = Locale.current.languageCode, let regionCode = Locale.current.regionCode else {
			return "en-US"
		}
		
		return "\(languageCode)-\(regionCode)"
	}
}
