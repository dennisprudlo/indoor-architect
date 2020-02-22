//
//  MCCoordinateToolStack.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import CoreLocation

class MCCoordinateToolStack: MCToolStack {
	
	private static let roundingPrecision: Double = 10000
	
	let latitudeItem = MCLabelToolStackItem()
	let longitudeItem = MCLabelToolStackItem()
	
	init() {
		super.init(forAxis: .horizontal)
		
		addItem(latitudeItem)
		addItem(longitudeItem)
		
		latitudeItem.isUserInteractionEnabled = false
		longitudeItem.isUserInteractionEnabled = false
		
		setCoordinate(nil)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func reset() {
		super.reset()
		setCoordinate(nil)
	}
	
	func setCoordinate(_ coordinate: CLLocationCoordinate2D?) -> Void {
		var latitudeString	= "--"
		var longitudeString	= "--"
		
		if let coordinate = coordinate {
			let roundedLatitude		= round(MCCoordinateToolStack.roundingPrecision * coordinate.latitude) / MCCoordinateToolStack.roundingPrecision
			let roundedLongitude	= round(MCCoordinateToolStack.roundingPrecision * coordinate.longitude) / MCCoordinateToolStack.roundingPrecision
			
			latitudeString	= roundedLatitude.description
			longitudeString	= roundedLongitude.description
		}
		
		let defaultFont = latitudeItem.titleLabel.font
		
		let latitudeLabel = "Latitude"
		let attributedLatitudeString = NSMutableAttributedString(string: "\(latitudeLabel): \(latitudeString)", attributes: [
			NSAttributedString.Key.font:			UIFont.monospacedDigitSystemFont(ofSize: defaultFont!.pointSize, weight: .regular),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.tintColor
		])
		
		attributedLatitudeString.addAttributes([
			NSAttributedString.Key.font:			latitudeItem.titleLabel.font.bold(),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.prominentTintColor
		], range: NSRange(location: 0, length: latitudeLabel.count))
		
		let longitudeLabel = "Longitude"
		let attributedLongitudeString = NSMutableAttributedString(string: "\(longitudeLabel): \(longitudeString)", attributes: [
			NSAttributedString.Key.font:			UIFont.monospacedDigitSystemFont(ofSize: defaultFont!.pointSize, weight: .regular),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.tintColor
		])
		
		attributedLongitudeString.addAttributes([
			NSAttributedString.Key.font:			latitudeItem.titleLabel.font.bold(),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.prominentTintColor
		], range: NSRange(location: 0, length: longitudeLabel.count))
		
		latitudeItem.setAttributedTitle(attributedLatitudeString)
		longitudeItem.setAttributedTitle(attributedLongitudeString)
	}
}
