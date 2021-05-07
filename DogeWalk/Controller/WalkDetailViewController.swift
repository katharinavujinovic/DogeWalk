//
//  WalkDetailViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import MapKit
import RealmSwift

class WalkDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var walkDetailMapView: MKMapView!
    @IBOutlet weak var walkDetailCollectionView: UICollectionView!
    // Walk stats
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var walkTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let converter = Converter()
    
    var dogs: Results<Dog>?
    var walk: Walk! {
        didSet {
            loadWalks()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegation assigning
        walkDetailMapView.delegate = self
        walkDetailCollectionView.dataSource = self
        walkDetailCollectionView.delegate = self
        walkDetailCollectionView.backgroundColor = .clear
        // UI
        displaySelectedWalk()
    }
    
    func displaySelectedWalk() {
        dateLabel.text = timeFormatter(date: walk.date!)
        startTimeLabel.text = walk.startTime
        walkTimeLabel.text = converter.displayTime(seconds: walk.time)
        distanceLabel.text = converter.displayDistance(meter: walk.distance)
        do {
            if let unarchivedWalk = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [NSArray.self, CLLocation.self], from: walk.route) as? [CLLocation] {
                walkDetailMapView.addOverlay(createPolyLine(locations: unarchivedWalk))
            let viewRegion = MKCoordinateRegion(center: unarchivedWalk[0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            walkDetailMapView.setRegion(viewRegion, animated: true)
            }
        } catch {
            print("Rounte couldn't be unarchived, \(error)")
        }
    }
    
    private func loadWalks() {
        dogs = walk?.participatedDogs.sorted(byKeyPath: "name", ascending: true)
        DispatchQueue.main.async {
            self.walkDetailCollectionView.reloadData()
        }
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
        return dogs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniCell", for: indexPath) as! WalkDetailMiniCollectionViewCell
        if let dog = dogs?[indexPath.row] {
            let cellImage = UIImage(data: dog.profile)
            cell.miniImage.image = cellImage
        }
        return cell
    }
}

