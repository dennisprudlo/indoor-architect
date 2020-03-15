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
	
	let canvas				= MCMapCanvas()
	
	var project: IMDFProject!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		canvas.delegate		= self
		canvas.controller	= self
		
		view.addSubview(canvas)
		canvas.edgesToSuperview()
	}
	
	override func viewDidLayoutSubviews() {
		canvas.distanceRuler.ruler.frame = canvas.frame
	}
	
	func present(forProject project: IMDFProject) -> Void {
		self.project = project
		self.modalPresentationStyle = .fullScreen
		
		canvas.project = project
		canvas.selectedDrawingTool = .pointer
	
		canvas.generateIMDFOverlays()
		
		if let session = project.manifest.session {
			let center	= CLLocationCoordinate2D(latitude: session.centerLatitude, longitude: session.centerLongitude)
			let span	= MKCoordinateSpan(latitudeDelta: session.spanLatitude, longitudeDelta: session.spanLongitude)
			let region	= MKCoordinateRegion(center: center, span: span)
			canvas.setRegion(region, animated: true)
		}
		
		Application.rootController.present(self, animated: true, completion: nil)
	}
	
	func mapCanvas(_ canvas: MCMapCanvas, didTapOn location: CLLocationCoordinate2D, with drawingTool: MCMapCanvas.DrawingTool) {
		canvas.coordinateToolStack.setCoordinate(location)
		
		if drawingTool == .anchor {
			canvas.addAnchor(at: location)
		}
	}
	
	func mapCanvas(_ canvas: MCMapCanvas, didSwitch drawingTool: MCMapCanvas.DrawingTool) {
		if drawingTool != .measure {
			canvas.distanceRuler.invalidate()
			canvas.distanceRuler.releaseRecognizersForMeasuring()
		} else {
			canvas.distanceRuler.holdRecognizersForMeasuring()
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		return MKOverlayRenderer()
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
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		let centerLat	= mapView.region.center.latitude
		let centerLng	= mapView.region.center.longitude
		let spanLat		= mapView.region.span.latitudeDelta
		let spanLng		= mapView.region.span.longitudeDelta
		let session = IMDFProjectManifest.MappingSession(centerLatitude: centerLat, centerLongitude: centerLng, spanLatitude: spanLat, spanLongitude: spanLng)
	
		project.manifest.session = session
	}
}
