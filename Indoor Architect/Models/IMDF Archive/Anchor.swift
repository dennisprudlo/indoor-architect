//
//  Anchor.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation
import MapKit

class Anchor: Feature<Anchor.Properties> {
	
	var address: Address? {
		didSet {
			self.properties.addressId = address?.id
		}
	}
	
	var unit: Unit? {
		didSet {
			self.properties.unitId = unit?.id
		}
	}

	/// The anchors properties
	struct Properties: Codable {
		/// Reference to an address entry for this anchor
		var addressId:		IMDFType.FeatureID?
		
		/// Reference to a unit entry for this anchor
		var unitId:			IMDFType.FeatureID?
		
		/// A comment for the feature
		var information:	IMDFType.EntityInformation?
		
		func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(addressId,		forKey: .addressId)
			try container.encode(unitId,		forKey: .unitId)
			try container.encode(information,	forKey: .information)
		}
	}
	
	func set(comment: String?) -> Void {
		if properties.information == nil {
			properties.information = IMDFType.EntityInformation()
		}
		
		properties.information?.comment = comment
	}
	
	/// Gets the coordinates of the anchor
	func getCoordinates() -> CLLocationCoordinate2D {
		return geometry.first!.coordinate
	}
	
	/// Sets the coordinates of the anchor
	func setCoordinates(_ coordinates: CLLocationCoordinate2D) -> Void {
		let point = MKPointAnnotation()
		point.coordinate = coordinates
		
		self.geometry = [point]
	}
	
	/// Returns the anchor nearest to the tap position considering the threshold
	/// - Parameters:
	///   - point: The tap point position
	///   - canvas: The canvas where the user tapped
	/// - Returns: The anchor if there is any
	static func respondToSelection(in canvas: MCMapCanvas, point: CGPoint) -> Anchor? {
		let annotation = canvas.annotations.first { (annotation) -> Bool in
			guard let anchorAnnotation = annotation as? IMDFAnchorAnnotation else {
				return false
			}
			
			let anchorPoint = canvas.convert(anchorAnnotation.anchor.getCoordinates(), toPointTo: canvas)
			return point.distance(to: anchorPoint) < Address.selectionDistanceThreshold
		}
		
		return (annotation as? IMDFAnchorAnnotation)?.anchor
	}
}
