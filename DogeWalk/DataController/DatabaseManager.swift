//
//  DatabaseManager.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 02.08.21.
//

import Foundation
import RealmSwift

public class DatabaseManager {
    
    static var realm: Realm? {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch {
                print("Could not access REALM database", error)
                return nil
            }
        }
    }
    
    public static func write(realm: Realm?, writeClosure: () -> ()) {
        if realm != nil {
            do {
                try realm!.write {
                    writeClosure()
                }
            } catch {
                print("Could not write to REALM database", error)
            }
        } else {
            print("Cant write Objects, realm is nil!")
        }
    }
    
    public static func callResult<T: Object>(realm: Realm?, objectType: T.Type) -> Results<T>? {
        if realm != nil {
            return realm!.objects(objectType.self)
        } else {
            print("Cant fetch Objects, realm is nil!")
            return nil
        }
    }
    
    public static func callSortedResult<T: Object>(realm: Realm?, objectType: T.Type, sortedBy: String, ascending: Bool) -> Results<T>? {
        if realm != nil {
            return realm!.objects(objectType.self).sorted(byKeyPath: sortedBy, ascending: ascending)
        } else {
            print("Cant fetch sortedObjects, realm is nil!")
            return nil
        }
    }
    
}
