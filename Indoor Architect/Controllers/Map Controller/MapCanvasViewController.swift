//
//  MapCanvasViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/15/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MapKit

class MapCanvasViewController: UIViewController, MKMapViewDelegate, MCMapCanvasDelegate {

	static let shared		= MapCanvasViewController()
	
	let canvas				= MCMapCanvas()
	
	var project: IMDFProject!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		canvas.delegate = self
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
			canvas.addAnchor(at: location)
		} else if drawingTool == .measure {
			canvas.addMeasuringEdge(at: location)
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let ruler = overlay as? FlexibleRulerPolyline {
			let renderer = MKPolylineRenderer(overlay: ruler)
			renderer.strokeColor = UIColor.systemGray.withAlphaComponent(0.5)
			renderer.lineWidth = 5
			return renderer
		}
		
		return MKOverlayRenderer(overlay: overlay)
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let annotationView = PointAnnotationView(annotation: annotation, reuseIdentifier: nil)
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
		
		if newState == .ending, let annotation = view.annotation as? IMDFAnchorAnnotation {
			annotation.anchor.setCoordinates(annotation.coordinate)
		}
	}
}
