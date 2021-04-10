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
        walkDetailCollectionView.dataSource = self
        walkDetailCollectionView.delegate = self
        walkDetailMapView.addOverlay(walk.route as! MKOverlay)
        displaySelectedWalk()
    }

    
    //MARK: - PolyLineUnarchive
    
    func displaySelectedWalk() {
        dateLabel.text = "\(String(describing: walk.date))"
        startTimeLabel.text = walk.startTime
        walkTimeLabel.text = walk.time
        distanceLabel.text = walk.distance
        dogs = walk.value(forKey: "participatingDogs") as? [Dog]
    }
    func polylineUnarchive(polylineArchive: NSData) -> MKPolyline? {
        let data = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(polylineArchive as Data)
        let polyline = data as! [Dictionary<String, AnyObject>]

        var locations: [CLLocation] = []
        for item in polyline {
            if let latitude = item["latitude"]?.doubleValue,
                let longitude = item["longitude"]?.doubleValue {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                locations.append(location)
            }
        }
        var coordinates = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
        let fetchedPolyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        return fetchedPolyline
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
    
    func log(polyline: MKPolyline) {
        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: polyline.pointCount)
        polyline.getCoordinates(coordsPointer, range: NSMakeRange(0, polyline.pointCount))
        var coords: [Dictionary<String, AnyObject>] = []
        for i in 0..<polyline.pointCount {
            let latitude = NSNumber(value: coordsPointer[i].latitude)
            let longitude = NSNumber(value: coordsPointer[i].longitude)
            let coord = ["latitude" : latitude, "longitude" : longitude]
            coords.append(coord)
        }
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

