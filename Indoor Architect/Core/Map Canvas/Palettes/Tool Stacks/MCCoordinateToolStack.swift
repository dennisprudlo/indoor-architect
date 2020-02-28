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
			let numberFormatter = NumberFormatter()
			numberFormatter.minimumIntegerDigits = 1
			numberFormatter.minimumFractionDigits = 4
			numberFormatter.maximumFractionDigits = 4
			
			latitudeString	= numberFormatter.string(from: NSNumber(floatLiteral: coordinate.latitude)) ?? "--"
			longitudeString	= numberFormatter.string(from: NSNumber(floatLiteral: coordinate.longitude)) ?? "--"
		}
		
		let defaultFont = latitudeItem.titleLabel.font
		
		let latitudeLabel = "Lat"
		let attributedLatitudeString = NSMutableAttributedString(string: "\(latitudeLabel): \(latitudeString)", attributes: [
			NSAttributedString.Key.font:			UIFont.monospacedDigitSystemFont(ofSize: defaultFont!.pointSize, weight: .regular),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.tintColor
		])
		
		attributedLatitudeString.addAttributes([
			NSAttributedString.Key.font:			latitudeItem.titleLabel.font.bold(),
			NSAttributedString.Key.foregroundColor:	MCToolStackItem.prominentTintColor
		], range: NSRange(location: 0, length: latitudeLabel.count))
		
		let longitudeLabel = "Lng"
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
