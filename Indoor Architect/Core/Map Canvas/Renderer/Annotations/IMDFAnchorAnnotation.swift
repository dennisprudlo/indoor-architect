//
//  IMDFAnchorAnnotation.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class IMDFAnchorAnnotation: NSObject, MKAnnotation {
	
	var coordinate: CLLocationCoordinate2D
	
	var anchor: Anchor
	
	init(coordinate: CLLocationCoordinate2D, anchor: Anchor) {
		self.coordinate = coordinate
		self.anchor = anchor
	}

}
