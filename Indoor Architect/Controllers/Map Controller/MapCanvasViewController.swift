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
	
	let canvas = MCMapCanvas()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		canvas.delegate		= self
		canvas.controller	= self
		
		view.addSubview(canvas)
		canvas.edgesToSuperview()
	}
	
	func presentForSelectedProject() -> Void {
		if Application.currentProject == nil {
			return
		}
		
		self.modalPresentationStyle = .fullScreen
		
		canvas.selectedDrawingTool = .pointer
	
		canvas.renderFeatures()
		
		if let session = Application.currentProject.manifest.session {
			let center	= CLLocationCoordinate2D(latitude: session.centerLatitude, longitude: session.centerLongitude)
			let span	= MKCoordinateSpan(latitudeDelta: session.spanLatitude, longitudeDelta: session.spanLongitude)
			let region	= MKCoordinateRegion(center: center, span: span)
			canvas.setRegion(region, animated: true)
		}
		
		Application.rootController.present(self, animated: true, completion: nil)
	}
	
	func mapCanvas(_ canvas: MCMapCanvas, didTapOn location: CLLocationCoordinate2D, with drawingTool: MCMapCanvas.DrawingTool) {
		let tapPoint = canvas.convert(location, toPointTo: canvas)
		
		canvas.coordinateToolStack.setCoordinate(location)
		
		//
		// Determine the nearest feature and select it
		if drawingTool == .pointer {
			var featureEditController: FeatureEditController?

			//
			// Check for nearby anchors to edit
			if let anchor = Anchor.respondToSelection(in: canvas, point: tapPoint) {
				let controller			= AnchorsEditController(style: .insetGrouped)
				controller.anchor		= anchor
				controller.canvas		= canvas
				featureEditController	= controller
			}

			//
			// Check for nearby units to edit
			if featureEditController == nil, let unit = Unit.respondToSelection(in: canvas, coordinate: location) {
				let controller			= UnitsEditController(style: .insetGrouped)
				controller.unit			= unit
				controller.canvas		= canvas
				featureEditController	= controller
			}
			
			if let featureEditController = featureEditController {
				let navigationController	= UINavigationController(rootViewController: featureEditController)
				navigationController.modalPresentationStyle = .formSheet
				present(navigationController, animated: true, completion: nil)
				return
			}
		}
		
		if drawingTool == .anchor {
			let pointAssembler = MCPointAssembler(in: canvas)
			pointAssembler.add(location)
			canvas.addAnchor(pointAssembler.collect())
		}
		
		if drawingTool == .polygon {
			if canvas.polygonAssembler == nil {
				canvas.polygonAssembler = MCPolygonAssembler(in: canvas)
				canvas.showConfirmShapeButton()
			}
			
			canvas.polygonAssembler?.add(location)
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
		var isCurrentlyDrawing: Bool = false
		if let activeOverlay = canvas.getActiveShapeAssembler()?.activeOverlay {
			isCurrentlyDrawing = overlay === activeOverlay
		}
		
		let renderer: MKOverlayPathRenderer
		
		switch overlay {
			case is MKPolygon:
				renderer = MCPolygonRenderer(overlay: overlay, isCurrentlyDrawing)
			case is MKPolyline:
				renderer = MCPolylineRenderer(overlay: overlay, isCurrentlyDrawing)
			default:
				return MKOverlayRenderer(overlay: overlay)
		}
		
		return renderer
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
	
		Application.currentProject.manifest.session = session
	}
}
