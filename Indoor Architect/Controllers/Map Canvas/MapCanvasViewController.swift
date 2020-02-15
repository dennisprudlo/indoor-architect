//
//  MapCanvasViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/15/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class MapCanvasViewController: UIViewController {

	let map: MKMapView = MKMapView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.addSubview(map)
		map.translatesAutoresizingMaskIntoConstraints = false
		map.topAnchor.constraint(equalTo:		view.topAnchor).isActive = true
		map.trailingAnchor.constraint(equalTo:	view.trailingAnchor).isActive = true
		map.bottomAnchor.constraint(equalTo:	view.bottomAnchor).isActive = true
		map.leadingAnchor.constraint(equalTo:	view.leadingAnchor).isActive = true
    }

}
