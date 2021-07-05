//
//  Constants.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.03.21.
//

import Foundation
import UIKit

struct Constants {
    
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    struct Segue {
        static let dogOverviewToEdit = "DogOverviewToEdit"
        static let dogOverviewToDetail = "DogOverviewToDetail"
        static let dogDetailToEdit = "DogDetailToEdit"
        static let dogDetailToWalkDetail = "DogDetailToWalkDetail"
        static let dogOverviewToPreWalk = "DogOverviewToPreWalk"
        static let walkOverviewToPrewalk = "WalkOverviewToPreWalk"
        static let walkOverviewToDetail = "WalkOverviewToDetail"
        static let preWalkToCurrentWalk = "PreWalkToCurrentWalk"
        static let statsToPrewalk = "StatsToPreWalk"
        static let breedTableView = "breedTableView"
    }
    
    struct Nibs {
        static let dogMiniCollectionViewCell = "DogMiniCollectionViewCell"
        static let dogOverviewTableViewCell = "DogOverviewTableViewCell"
        static let walkOverviewTableViewCell = "WalksOverviewTableViewCell"
        static let dogSelectionCollectionViewCell = "DogSelectionCollectionViewCell"
        static let breedSelectorTableViewCell = "BreedSelectorTableViewCell"
    }
    
    struct AlertMessages {
        static let endOfWalkTitle = "Do you want to end the walk?"
        static let endOfWalkMessage = "By confirming, you walk will be ended and saved"
        static let stopWalk = "Stop and Save"
        static let continueWalk = "Continue Walk"
        static let dogSelectionTitle = "No Dog registered yet"
        static let dogSelectionMessage = "Make sure to create a profile for your dog before going for a walk"
        static let ok = "ok"
        static let missingName = "Please give your Dog a name"
        static let removeDogTitle = "Do you want to remove this dog?"
        static let removeDogMessage = "By confirming, this dog and all its walks will be deleted"
        static let removeDog = "Remove Dog"
        static let keepDog = "Keep Dog"
        static let addImageTitle = "Add Image"
        static let addImageMessage = "Select how you want to add an Image"
        static let fromLibrary = "Choose from Photo Library"
        static let fromCamera = "Take Picture with Camera"
    }
    
    struct SortedByKeyPath {
        static let start = "startDate"
        static let name = "name"
    }
    
}
