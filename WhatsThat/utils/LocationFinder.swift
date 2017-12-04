//
//  LocationFinder.swift
//  
//
//  Created by Chetan Mahajan on 11/27/17.
//

import Foundation
import CoreLocation


protocol LocationFinderDelegate {
    func locationFound(lat: Double, lon: Double)
    func locationNotFound()
}

class LocationFinder:NSObject {
    let locationManager = CLLocationManager()
    
    //let delegate = LocationFinderDelegate()
    var delegate: LocationFinderDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func findLocation() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            //print("location denied or restricted.")
            delegate?.locationNotFound()
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        }
    }
}

extension LocationFinder: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations.last!)
        let location = locations.first!
        delegate?.locationFound(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //TODO
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
