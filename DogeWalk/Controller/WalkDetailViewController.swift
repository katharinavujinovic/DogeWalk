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
    var dogs: [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nib registration
        let nib = UINib(nibName: "MiniCollectionViewCell", bundle: nil)
        walkDetailCollectionView.register(nib, forCellWithReuseIdentifier: "MiniCollectionViewCell")
        // delegation assigning
        walkDetailMapView.delegate = self
        walkDetailCollectionView.dataSource = self
        walkDetailCollectionView.delegate = self
        // UI
        walkDetailMapView.addOverlay(createPolyLine(locations: walk.route!))
        displaySelectedWalk()
    }
    
    func displaySelectedWalk() {
        dateLabel.text = timeFormatter(date: walk.date!)
        startTimeLabel.text = walk.startTime
        walkTimeLabel.text = walk.time
        distanceLabel.text = walk.distance
        let setOfDogs = walk.participatingDogs!
        dogs = setOfDogs.allObjects as! [Dog]
        let viewRegion = MKCoordinateRegion(center: walk.route![0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        walkDetailMapView.setRegion(viewRegion, animated: true)
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

//MARK: - Mini CollectionView
extension WalkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniCollectionViewCell", for: indexPath) as! MiniCollectionViewCell
        cell.dogImage.image = UIImage(data: dogs[indexPath.row].profile!)
        return cell
    }
}

