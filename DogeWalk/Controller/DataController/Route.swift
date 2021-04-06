//
//  Route.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 06.04.21.
//

import Foundation
import MapKit

class Route: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true
    
    var route: MKPolyline
    
    init(route: MKPolyline) {
        self.route = route
    }

    required init?(coder: NSCoder) {
        self.route = coder.decodeObject(forKey: "route") as! MKPolyline
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(route, forKey: "route")
    }
}
