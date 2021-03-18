//
//  WalkDetailViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import MapKit
import CoreData

class WalkDetailViewController: UIViewController {
    
    @IBOutlet weak var walkDetailMapView: MKMapView!
    @IBOutlet weak var walkDetailCollectionView: UICollectionView!
    // Walk stats
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var walkTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    

    
    
}
