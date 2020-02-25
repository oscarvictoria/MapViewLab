//
//  LocationSession.swift
//  MapViewLab
//
//  Created by Oscar Victoria Gonzalez  on 2/24/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import Foundation
import CoreLocation


class CoreLocationSession: NSObject {
    
    public var locationManager: CLLocationManager!
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        
        // the following key's need to be added to the info.plist file
        // NSLocationAlwaysAndWhenInUseUsageDescription
        // NSLocationWhenInUseUsageDescription
        
        // get updates for user location
        
        startSignificantLocationChanges()
        
        //         startMonitoringRegion()
    }
    
    private func startSignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func convertCordinateToPlacemark(cordinate: CLLocationCoordinate2D) {
        // we will use the CLGeocoder() class for converting cordinate (CLLocationCoordinate2D) to placemark (CLPlacemark)
        
        let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("reversedGeocodeLocation: \(error)")
            }
            if let firstPlaceMark = placemarks?.first {
                print("placemark info: \(firstPlaceMark)")
            }
        }
        
    }
    
    public func convertPlaceNameToCoordinate(addressString: String, completion: @escaping (Result <CLLocationCoordinate2D, Error>)->()) {
        // coverting an address to a coordinate
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                print("geocodeAddressString: \(error)")
                completion(.failure(error))
            }
            if let firstPlacemark = placemarks?.first,
                let location = firstPlacemark.location {
                print("place name coordinate is \(location.coordinate)")
                completion(.success(location.coordinate))
            }
        }
    }
    
}

extension CoreLocationSession: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocation: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion \(region)")
    }
}
