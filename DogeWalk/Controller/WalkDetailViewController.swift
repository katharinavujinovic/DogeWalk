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
    var selectedAnnotation: String?
    
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
        let nib = UINib(nibName: "DogMiniCollectionViewCell", bundle: nil)
        walkDetailCollectionView.register(nib, forCellWithReuseIdentifier: "DogMiniCollectionViewCell")
        walkDetailCollectionView.dataSource = self
        walkDetailCollectionView.delegate = self
        walkDetailCollectionView.backgroundColor = .clear
        // UI
        displaySelectedWalk()
    }
    
    func displaySelectedWalk() {
        dateLabel.text = converter.startTime(date: walk.startDate)
        startTimeLabel.text = converter.dayFormatter(date: walk.startDate)
        walkTimeLabel.text = converter.displayTime(seconds: walk.time)
        distanceLabel.text = converter.displayDistance(meter: walk.distance)
        do {
            if let unarchivedWalk = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [CLLocation.self], from: walk.route) as? [CLLocation] {
                walkDetailMapView.addOverlay(createPolyLine(locations: unarchivedWalk))
            let viewRegion = MKCoordinateRegion(center: unarchivedWalk[0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            walkDetailMapView.setRegion(viewRegion, animated: true)
            }
        } catch {
            print("Rounte couldn't be unarchived, \(error)")
        }
        
        if let unarchivedPoopAnnotation = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [CLLocation.self], from: walk.poopAnnotation) as? [CLLocation] {
            DispatchQueue.main.async {
                self.selectedAnnotation = "poopAnnotation"
                self.populateMapViewWithAnnotations(locationsToPopulate: unarchivedPoopAnnotation)
            }
        }
        if let unarchivedPeeAnnotation = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [CLLocation.self], from: walk.peeAnnotation) as? [CLLocation] {
            self.selectedAnnotation = "peeAnnotation"
            self.populateMapViewWithAnnotations(locationsToPopulate: unarchivedPeeAnnotation)
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
    
    //Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if selectedAnnotation == "poopAnnotation" {
            let reuseId = "poopPin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.image = #imageLiteral(resourceName: "PoopAnnotation")
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        } else if selectedAnnotation == "peeAnnotation" {
            let reuseId = "peePin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.image = #imageLiteral(resourceName: "PeeAnnotation")
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        } else {
            let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
            pinView?.annotation = annotation
            return pinView
        }
    }
      
    func populateMapViewWithAnnotations(locationsToPopulate: [CLLocation]) {
        if selectedAnnotation == "poopAnnotation" {
            for annotationToPopulate in locationsToPopulate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = annotationToPopulate.coordinate
                DispatchQueue.main.async {
                    self.walkDetailMapView.addAnnotation(annotation)
                }
                print("added poopAnnotation")
            }
        } else if selectedAnnotation == "peeAnnotation" {
            for annotationToPopulate in locationsToPopulate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = annotationToPopulate.coordinate
                walkDetailMapView.addAnnotation(annotation)
                print("added peeAnnotation")
            }
        }
    }
    
}

//MARK: - Mini CollectionView
extension WalkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogMiniCollectionViewCell", for: indexPath) as! DogMiniCollectionViewCell
        if let dog = dogs?[indexPath.row] {
            let cellImage = UIImage(data: dog.profile)
            cell.dogImage.image = cellImage
        }
        return cell
    }
}

