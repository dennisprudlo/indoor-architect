//
//  MapCanvasViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/15/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class MapCanvasViewController: UIViewController, MCMapCanvasDelegate {

	static let shared		= MapCanvasViewController()
	
	let canvas				= MCMapCanvas()
	
	var project: IMDFProject!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		canvas.drawingDelegate = self
		
		view.addSubview(canvas)
		canvas.edgesToSuperview()
	}
	
	func present(forProject project: IMDFProject) -> Void {
		self.project = project
		self.modalPresentationStyle = .fullScreen
		
		canvas.project = project
		canvas.toolPalette.reset()
		canvas.toolPalette.reset()
		canvas.selectedDrawingTool = .pointer
	
		canvas.remakeMap()
		
		Application.rootController.present(self, animated: true, completion: nil)
	}
	
	func mapCanvas(_ canvas: MCMapCanvas, didTapOn location: CLLocationCoordinate2D, with drawingTool: MCMapCanvas.DrawingTool) {
		canvas.toolPalette.coordinateToolStack.setCoordinate(location)
		
		if drawingTool == .anchor {
			let uuid = project.imdfArchive.getUnusedGlobalUuid()
			let properties = Anchor.Properties(addressId: nil, unitId: nil)
			let point = MKPointAnnotation()
			point.coordinate = location
			let anchor = Anchor(withIdentifier: uuid, properties: properties, geometry: [point], type: .anchor)
			project.imdfArchive.anchors.append(anchor)
			
			try? project.imdfArchive.save(.anchor)
	
			if let geometry = anchor.geometry.first {
				canvas.addAnnotation(geometry)
			}
		}
	}
}
