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
