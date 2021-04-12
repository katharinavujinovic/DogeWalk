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
    }
    
}
