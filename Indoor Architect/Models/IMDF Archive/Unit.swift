//
//  Unit.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import CoreGraphics
import MapKit

class Unit: Feature<Unit.Properties> {

	/// The units properties
	struct Properties: Codable {
		/// The units category. Use one of the predefined categories that fits the most
		var category:		IMDFType.UnitCategory = .unspecified
		
		/// The units restriction category
		var restriction:	IMDFType.Restriction?
		
		/// The units name
		var accessibility:	IMDFType.Accessibility?
		
		/// The units name
		var name:			IMDFType.Labels?
		
		/// The units alternative name. This can be used for internal names
		var altName:		IMDFType.Labels?
		
		/// Reference to a level feature for this unit
		var levelId:		IMDFType.FeatureID?
		
		/// The units display point
		var displayPoint:	IMDFType.PointGeometry?
		
		/// The features meta information
		var information:	IMDFType.EntityInformation?
		
		func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(category,		forKey: .category)
			try container.encode(restriction,	forKey: .restriction)
			try container.encode(accessibility,	forKey: .accessibility)
			try container.encode(name,			forKey: .name)
			try container.encode(altName,		forKey: .altName)
			try container.encode(levelId,		forKey: .levelId)
			try container.encode(displayPoint,	forKey: .displayPoint)
			try container.encode(information,	forKey: .information)
		}
	}
	
	func set(comment: String?) -> Void {
		if properties.information == nil {
			properties.information = IMDFType.EntityInformation()
		}
		
		properties.information?.comment = comment
	}
	
	static func respondToSelection(in canvas: MCMapCanvas, coordinate: CLLocationCoordinate2D) -> Unit? {
		return canvas.overlays.compactMap({ $0 as? IMDFUnitOverlay }).first(where: { $0.contains(coordinate: coordinate) })?.unit
	}
}
