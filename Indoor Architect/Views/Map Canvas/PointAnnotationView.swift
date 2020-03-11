//
//  PointAnnotationView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import MapKit

class PointAnnotationView: MKAnnotationView {
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		
		self.frame				= CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 10, height: 10)
		self.backgroundColor = Color.primary
		self.layer.cornerRadius	= 5
		self.layer.borderWidth	= 1.0
		self.layer.borderColor	= Color.primary.cgColor
		isDraggable = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
