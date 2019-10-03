//
//  ViewController.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerOutput {
    func visibleMapRegionChanged(center: Location, bufferRadius: Double, bufferMinLongitude: Double, bufferMaxLongitude: Double, bufferMinLatitude: Double, bufferMaxLatitude: Double)
    func icon(for: DepositionPoint, completion: @escaping (UIImage?) -> Void)
}

protocol MapViewControllerInput: class {
    func showPoints(_: [DepositionPoint])
}

class MapViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Injected dependecies
    var output: MapViewControllerOutput!
    
    // MARK: - Private properties
    private var allAnnotationsMapView: MKMapView!
    private var locationManager = CLLocationManager()
    private let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    private var hasInitiallyZoomedToUserLocation = false
    private var lastBufferMapRect: MKMapRect?
    private let throttlingInterval: TimeInterval = 1
    private let defaultMapBufferOffset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allAnnotationsMapView = MKMapView(frame: CGRect.zero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(DepositionPointAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        locationManager.requestWhenInUseAuthorization()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let coordinate = CLLocationCoordinate2D(latitude: 55.755786, longitude: 37.617633)
        zoomToLocation(coordinate: coordinate)
    }
    
    // MARK: - Private Methods
    private func zoomToLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: defaultSpan)
        mapView.setRegion(region, animated: false)
    }
    
    func updateVisibleAnnotations() {
        
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !hasInitiallyZoomedToUserLocation {
//            zoomToLocation(coordinate: userLocation.coordinate)
//            hasInitiallyZoomedToUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleRect = mapView.visibleMapRect
        if let lastBufferRect = lastBufferMapRect, lastBufferRect.contains(visibleRect) {
            return
        }
        let bufferRect = visibleRect//mapView.mapRectThatFits(visibleRect, edgePadding: defaultMapBufferOffset)
        lastBufferMapRect = bufferRect
        
        let centerCoordinate = mapView.region.center
        let centerLocation = Location(coordinate: centerCoordinate)
        let centerPoint = MKMapPoint(centerCoordinate)
        
        let minXPoint = MKMapPoint(x: bufferRect.minX, y: 0)
        let minYPoint = MKMapPoint(x: 0, y: bufferRect.minY)
        let maxXPoint = MKMapPoint(x: bufferRect.maxX, y: 0)
        let maxYPoint = MKMapPoint(x: 0, y: bufferRect.maxY)
        
        let distance = centerPoint.distance(to: bufferRect.origin)
        output.visibleMapRegionChanged(center: centerLocation, bufferRadius: distance, bufferMinLongitude: minXPoint.coordinate.longitude, bufferMaxLongitude: maxXPoint.coordinate.longitude, bufferMinLatitude: maxYPoint.coordinate.latitude, bufferMaxLatitude: minYPoint.coordinate.latitude)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let depositionPointAnnotation = annotation as? DepositionPointAnnotation else {
//            return nil
//        }
//        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: DepositionPointAnnotationView.defaultReuseIdentifier, for: annotation) as? DepositionPointAnnotationView else {
//            return nil
//        }
//        output.icon(for: depositionPointAnnotation.depositionPoint) { [weak annotationView] (image) in
////            annotationView?.imageView.image = image
//        }
//        return annotationView
//    }
    
}

extension MapViewController: MapViewControllerInput {
    func showPoints(_ points: [DepositionPoint]) {
        allAnnotationsMapView.removeAnnotations(allAnnotationsMapView.annotations)
        let annotations = points.map {
            DepositionPointAnnotation(depositionPoint: $0)
        }
        allAnnotationsMapView.addAnnotations(annotations)
    }
}
