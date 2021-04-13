//
//  LocationService.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 13.04.21.
//

import Foundation
import UIKit
import MapKit

extension CurrentWalkViewController {
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // show alert to let user know why they need to enable this
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            currentWalkMapView.showsUserLocation = true
        case.denied:
            // show alert to turn on locationservice
        break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            currentWalkMapView.showsUserLocation = true
        case .restricted:
            // show alert that locationusage is restricted
        break
        case .authorizedAlways:
            break
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
            currentWalkMapView.showsUserLocation = true
        }
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
}
