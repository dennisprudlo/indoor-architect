//
//  PointAnnotationView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 3/11/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import MapKit

class PointAnnotationView: MKAnnotationView {
	
	private let diameter: CGFloat = 10
	
	private let borderWidth: CGFloat = 0.5
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		
		self.frame				= CGRect(x: self.frame.origin.x - (diameter / 2), y: self.frame.origin.y - (diameter / 2), width: diameter, height: diameter)
		self.backgroundColor	= Color.anchorPointAnnotationTint
		self.layer.cornerRadius	= diameter / 2
		self.layer.borderWidth	= borderWidth
		self.layer.borderColor	= Color.anchorPointAnnotationBorder.cgColor
		isDraggable = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
