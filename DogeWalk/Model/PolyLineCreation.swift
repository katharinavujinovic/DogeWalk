//
//  PolyLineCreation.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 13.04.21.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {
    
    func createPolyLine(locations: [CLLocation]) -> MKPolyline {
        let coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        let polyLine = MKPolyline(coordinates: coordinates, count: locations.count)
        return polyLine
    }
    
}
