//
//  ViewController.swift
//  MapViewLab
//
//  Created by Oscar Victoria Gonzalez  on 2/24/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationSession = CoreLocationSession()
    
    var schools = [Results]() {
        didSet {
            loadMap()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        loadSchools()
        loadMap()
    }
    
    private func loadMap() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
    }
    
    private func makeAnnotations()-> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in schools {
            let annotation = MKPointAnnotation()
            annotation.title = location.school_name
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
            annotations.append(annotation)
        }
        return annotations
    }
    
    
    func loadSchools() {
        NYCSchoolsAPIClient.getSchools { (result) in
            switch result {
            case .failure(let appError):
                print("app Error: \(appError)")
            case .success(let results):
                self.schools = results
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        
        let identifier = "LocatioAnnotation"
        var annotationView: MKPinAnnotationView
        // try to deque
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = dequeView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccesoryControllTaped")
    }
}
