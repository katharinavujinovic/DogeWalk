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

class WalkDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var walkDetailMapView: MKMapView!
    @IBOutlet weak var walkDetailCollectionView: UICollectionView!
    // Walk stats
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var walkTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var walk: Walk!
    var dogs: [Dog]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkDetailMapView.delegate = self
        displaySelectedWalk()
    }

    
    //MARK: - PolyLineUnarchive
    
    func displaySelectedWalk() {
        dateLabel.text = "\(String(describing: walk.date))"
        startTimeLabel.text = walk.startTime
        walkTimeLabel.text = walk.time
        distanceLabel.text = walk.distance
        walkDetailMapView.addOverlay(walk.route as! MKPolyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1)
            polyLineRenderer.lineWidth = 5
            return polyLineRenderer
        }
        return MKOverlayRenderer()
    }
}

// display the dogs in your collectionView

