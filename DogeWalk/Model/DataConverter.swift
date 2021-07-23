//
//  DataConverter.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 13.04.21.
//

import Foundation
import UIKit
import MapKit
import RealmSwift

extension UIViewController {
    
    func createPolyLine(locations: [CLLocation]) -> MKPolyline {
        let coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        let polyLine = MKPolyline(coordinates: coordinates, count: locations.count)
        return polyLine
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func realmDogResultToArray(realmResult: Results<Dog>) -> [Dog] {
        var allDogs = [Dog]()
        for dog in realmResult {
            allDogs.append(dog)
        }
        return allDogs
    }
    
    func realmWalkResultToArray(realmResult: Results<Walk>) -> [Walk] {
        var walks = [Walk]()
        for walk in realmResult {
            walks.append(walk)
        }
        return walks
    }
    
//MARK: - fetchFilteredDogs
    func fetchFilteredDogs(arrayOfDogNames: [String], allDogs: [Dog]) -> [Dog] {
        var filterOfDogs = [Dog]()
        for name in arrayOfDogNames {
            for dog in allDogs {
                if name == dog.name {
                    filterOfDogs.append(dog)
                }
            }
        }
        return filterOfDogs
    }
    
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
    
//MARK: - isSelected
    func dogCellIsSelected(nameOfDog: String, allDogs: [Dog]) -> Bool {
        var cellIsSelected = false
        for dog in allDogs {
            if dog.name == nameOfDog {
                cellIsSelected = true
            }
        }
        return cellIsSelected
    }
    
    func sortingCellIsSelected(labelOfCell: String) -> Bool {
        var userDefaultString = ""
        
        switch UserDefaults.standard.string(forKey: "sortBy") {
        case "distance":
            userDefaultString = "Distance"
        case "startDate":
            userDefaultString = "Date"
        case "time":
            userDefaultString = "Duration"
        default:
            userDefaultString = "Date"
        }
        
        if labelOfCell == userDefaultString {
            return true
        } else {
            return false
        }
    }
    
}
