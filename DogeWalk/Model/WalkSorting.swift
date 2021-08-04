//
//  WalkSorting.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 25.07.21.
//

import Foundation
import RealmSwift

class WalkSorting {
    
//    let realm = try! Realm()
    
    func realmResultToArray<T>(realmResult: Results<T>) -> [T] {
        var allDogs = [T]()
        for dog in realmResult {
            allDogs.append(dog)
        }
        return allDogs
    }
    
//MARK: - Fetch Walks
        func walksForFetchedDogs(filteredDogs: [Dog]) -> [Walk] {
            var walkOfFilteredDog = [Walk]()
            var allWalks = [Walk]()
            for filterDog in filteredDogs {
                let walkPerDogResult = filterDog.participatedWalks
                    for walk in walkPerDogResult {
                        walkOfFilteredDog.append(walk)
                    }
            }
            walkOfFilteredDog.sort {
                $0.startDate < $1.startDate
            }
            for walk in walkOfFilteredDog {
                if allWalks.count == 0 {
                    allWalks.append(walk)
                } else {
                    if walk.time != allWalks.last?.time {
                        allWalks.append(walk)
                    }
                }
            }
            let sortedWalks = returnSortedWalks(allWalksFromSelectedDogs: allWalks)
            return sortedWalks
        }
        
//MARK: - returnSortedWalks
        func returnSortedWalks(allWalksFromSelectedDogs: [Walk]) -> [Walk] {
            
            var unsortedWalks = allWalksFromSelectedDogs
            
            if UserDefaults.standard.bool(forKey: "ascend") {
                    switch UserDefaults.standard.string(forKey: "sortBy") {
                    case "distance":
                        unsortedWalks.sort {
                            $0.distance < $1.distance
                        }
                    case "startDate":
                        unsortedWalks.sort {
                            $0.startDate < $1.startDate
                        }
                    case "time":
                        unsortedWalks.sort {
                            $0.time < $1.time
                        }
                    default:
                        unsortedWalks.sort {
                            $0.startDate < $1.startDate
                        }
                    }
            } else {
                switch UserDefaults.standard.string(forKey: "sortBy") {
                case "distance":
                    unsortedWalks.sort {
                        $0.distance > $1.distance
                    }
                case "startDate":
                    unsortedWalks.sort {
                        $0.startDate > $1.startDate
                    }
                case "time":
                    unsortedWalks.sort {
                        $0.time > $1.time
                    }
                default:
                    unsortedWalks.sort {
                        $0.startDate > $1.startDate
                    }
                }
            }
            return unsortedWalks
        }
        
//MARK: - SortingCellSelection
    func sortingCellIsSelected() -> Int {
        switch UserDefaults.standard.string(forKey: "sortBy") {
            case "distance":
                return 0
            case "startDate":
                return 1
            case "time":
                return 2
            default:
                return 1
            }
        }
    
    func changeDogSelectionValue(select: Bool, changeDogs: [Dog]) {
        for everyDog in changeDogs {
//            do {
                if let nonOptionalRealm = DatabaseManager.realm {
                    DatabaseManager.write(realm: nonOptionalRealm) {
                        everyDog.isSelectedForWalkFilter = select
                    }
                }
                /*
                try realm.write {
                    everyDog.isSelectedForWalkFilter = select
                }

            } catch {
                print("Error setting all dog.isSelectedForWalkFilter to \(select) after done is pressed")
            }
                 */
        }
    }
    
    func changeAllDogsValue(select: Bool, allDogs: Results<Dog>) {
        for everyDog in allDogs {
//            do {
            if let nonOptionalRealm = DatabaseManager.realm {
                DatabaseManager.write(realm: nonOptionalRealm) {
                    everyDog.isSelectedForWalkFilter = select
                }
            }
            /*
                try realm.write {
                    everyDog.isSelectedForWalkFilter = select
                }
            } catch {
                print("Error setting all dog.isSelectedForWalkFilter to false after done is pressed")
            }
             */
        }
    }
    
}
