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

	static let shared		= MapCanvasViewController()
	
	let canvas				= MCMapCanvas()
	
	var project: IMDFProject!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.addSubview(canvas)
		canvas.edgesToSuperview()
	}
	
	func present(forProject project: IMDFProject) -> Void {
		self.project = project
		self.modalPresentationStyle = .fullScreen
		
		canvas.generalToolsPalette.reset()
		canvas.drawingToolsPalette.reset()
		canvas.selectedDrawingTool = .pointer
		
		Application.rootViewController.present(self, animated: true, completion: nil)
	}
}
