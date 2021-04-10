//
//  RouteValueTransformer.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 06.04.21.
//

import Foundation
import UIKit
import MapKit
import CoreData

@objc(RouteValueTransformer)
final class RouteValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return Route.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let route = value as? Route else {
            return nil
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: route, requiringSecureCoding: true)
            return data
        } catch {
            assertionFailure("Failed to transform MKPolyline to Data")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {
            return nil
        }
        do {
            let route = try NSKeyedUnarchiver.unarchivedObject(ofClass: Route.self, from: data as Data)
            return route
        } catch {
            assertionFailure("Failed to transform Data to MKPolyline")
            return nil
        }
    }
}

extension RouteValueTransformer {
    
    static let name = NSValueTransformerName(rawValue: String(describing: RouteValueTransformer.self))
    
    public static func register() {
        let transformer = RouteValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
