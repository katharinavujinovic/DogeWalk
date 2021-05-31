//
//  Walk.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 04.05.21.
//

import Foundation
import RealmSwift

class Walk: Object {
    @objc dynamic var startDate = Date()
    @objc dynamic var distance: Double = 0.0
    @objc dynamic var route = Data()
    @objc dynamic var time: Int = 0
    @objc dynamic var poopAnnotation = Data()
    @objc dynamic var peeAnnotation = Data()
    var participatedDogs = LinkingObjects(fromType: Dog.self, property: "participatedWalks")
}
