//
//  Walk+CoreDataProperties.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 02.04.21.
//

import Foundation
import CoreData
import MapKit

extension Walk {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var distance: String
    @NSManaged public var route: MKPolyLine
    @NSManaged public var startTime: String
    @NSManaged public var time: String
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        date = Date()
    }
}
