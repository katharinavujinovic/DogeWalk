//
//  Dog.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 04.05.21.
//

import Foundation
import RealmSwift

class Dog: Object {
    @objc dynamic var name: String = "Unknown Dog"
    @objc dynamic var profile = Data()
    @objc dynamic var age: Date?
    @objc dynamic var breed: String?
    @objc dynamic var isFemale: Bool = true
    @objc dynamic var weight: Double = 0.0
    @objc dynamic var height: Double = 0.0
    @objc dynamic var neutered: Bool = false
    @objc dynamic var favouriteToy: String?
    @objc dynamic var favouriteTreat: String?
    @objc dynamic var chipID: String?
    @objc dynamic var isSelectedForWalkFilter: Bool = true
    var participatedWalks = List<Walk>()
}

