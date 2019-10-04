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
    private var locationManager = CLLocationManager()
    private var allAnnotationsMapView: MKMapView!
    private var allPoints: [DepositionPoint] = []
    private var maxBufferRect: MKMapRect?
    private let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    private let marginFactor = 0.1
    private let bucketSize = 100.0
    private var hasInitiallyZoomedToUserLocation = false
    private let animationDuration = 0.2
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allAnnotationsMapView = MKMapView(frame: CGRect.zero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(DepositionPointAnnotationView.self, forAnnotationViewWithReuseIdentifier: DepositionPointAnnotationView.defaultReuseIdentifier)
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
    
    private func annotation(in grid: MKMapRect, using annotations: Set<DepositionPointAnnotation>) -> DepositionPointAnnotation {
        let visibleAnnotationsInBucket = mapView.annotations(in: grid)
        if let shown = annotations.first(where: { (element) -> Bool in
            visibleAnnotationsInBucket.contains(element)
        }) {
            return shown
        }
        let centerGridPoint = MKMapPoint(x: grid.midX, y: grid.midY)
        let sorted = annotations.sorted { (prev, next) -> Bool in
            let prevDist = centerGridPoint.distance(to: MKMapPoint(prev.coordinate))
            let nextDist = centerGridPoint.distance(to: MKMapPoint(next.coordinate))
            return prevDist <= nextDist
        }
        return sorted.first!
    }
    
    private func updateVisibleAnnotations() {
        let visibleRect = mapView.visibleMapRect
        let adjustedRect = visibleRect.insetBy(dx: -marginFactor * visibleRect.width, dy: -marginFactor * visibleRect.height)
        
        let leftCoordinate = mapView.convert(CGPoint.zero, toCoordinateFrom: mapView)
        let rightCoordinate = mapView.convert(CGPoint(x: bucketSize, y: 0), toCoordinateFrom: mapView)
        let gridSize = MKMapPoint(rightCoordinate).x - MKMapPoint(leftCoordinate).x
        var gridMapRect = MKMapRect(x: 0, y: 0, width: gridSize, height: gridSize)
        
        let startX = (adjustedRect.minX / gridSize).rounded(.down) * gridSize
        let startY = (adjustedRect.minY / gridSize).rounded(.down) * gridSize
        let endX = (adjustedRect.maxX / gridSize).rounded(.down) * gridSize
        let endY = (adjustedRect.maxY / gridSize).rounded(.down) * gridSize
        
        var numberOfGrids = 0
        gridMapRect.origin.y = startY
        while gridMapRect.minY <= endY {
            gridMapRect.origin.x = startX
            while gridMapRect.minX <= endX {
                let allAnnotationsInBucket = allAnnotationsMapView.annotations(in: gridMapRect)
                let visibleAnnotationsInBucket = mapView.annotations(in: gridMapRect)
                var filteredAnnotationsInBucket = allAnnotationsInBucket.filter { $0 is DepositionPointAnnotation } as! Set<DepositionPointAnnotation>
                if !filteredAnnotationsInBucket.isEmpty {
                    let annotationForGrid = annotation(in: gridMapRect, using: filteredAnnotationsInBucket)
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotationForGrid)
                    }
                    filteredAnnotationsInBucket.remove(annotationForGrid)
                    filteredAnnotationsInBucket.forEach { (annotation) in
                        if (visibleAnnotationsInBucket.contains(annotation)) {
                            DispatchQueue.main.async {
                                let annotationView = self.mapView.view(for: annotation)
                                UIView.animate(withDuration: self.animationDuration, animations: {
                                    annotationView?.alpha = 0
                                }) { (completed) in
                                    self.mapView.removeAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
                gridMapRect.origin.x += gridSize
                numberOfGrids += 1
            }
            gridMapRect.origin.y += gridSize
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !hasInitiallyZoomedToUserLocation {
//            zoomToLocation(coordinate: userLocation.coordinate)
            hasInitiallyZoomedToUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleRect = mapView.visibleMapRect
        let bufferRect = visibleRect.insetBy(dx: -marginFactor * visibleRect.width, dy: -marginFactor * visibleRect.height)
//        if let maxRect = maxBufferRect {
//            if maxRect.contains(bufferRect) {
//                DispatchQueue.global().async {
//                    self.updateVisibleAnnotations()
//                }
////                return
//            }
//        }
//        maxBufferRect = bufferRect
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let depositionPointAnnotation = annotation as? DepositionPointAnnotation else {
            return nil
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: DepositionPointAnnotationView.defaultReuseIdentifier, for: annotation) as? DepositionPointAnnotationView else {
            return nil
        }
        output.icon(for: depositionPointAnnotation.depositionPoint) { [weak annotationView] (image) in
            annotationView?.imageView.image = image
        }
        annotationView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: animationDuration) {
            views.forEach { $0.alpha = 1 }
        }
    }
    
}

extension MapViewController: MapViewControllerInput {
    func showPoints(_ points: [DepositionPoint]) {
        DispatchQueue.global().async {
            let newPoints = points.filter { (point) -> Bool in
                return !self.allPoints.contains(point)
            }
            let annotations = newPoints.map { DepositionPointAnnotation(depositionPoint: $0) }
            self.allAnnotationsMapView.addAnnotations(annotations)
            self.updateVisibleAnnotations()
        }
    }
}
