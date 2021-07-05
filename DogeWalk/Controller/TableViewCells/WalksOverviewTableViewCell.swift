//
//  WalksOverviewTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.03.21.
//

import UIKit
import MapKit
import RealmSwift

class WalksOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var miniCollectionView: UICollectionView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var distancelabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var poopAnnotation = [CLLocation]()
    var peeAnnotation = [CLLocation]()
    private var selectedAnnotation: String?
    var participatedDogsForWalk: [Dog]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "DogMiniCollectionViewCell", bundle: nil)
        miniCollectionView.register(nib, forCellWithReuseIdentifier: "DogMiniCollectionViewCell")
        miniCollectionView.dataSource = self
        miniCollectionView.delegate = self
        mapView.delegate = self
    }
    
}

extension WalksOverviewTableViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1)
            polyLineRenderer.lineWidth = 5
            return polyLineRenderer
        }
        return MKOverlayRenderer()
    }
    
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
    
    func populateMapViewWithAnnotations(iconToPopulate: String) {
        selectedAnnotation = iconToPopulate
        
        if selectedAnnotation == "poopAnnotation" {
            for annotationToPopulate in poopAnnotation {
                let annotation = MKPointAnnotation()
                annotation.coordinate = annotationToPopulate.coordinate
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                }
            }
        } else if selectedAnnotation == "peeAnnotation" {
            for annotationToPopulate in peeAnnotation {
                let annotation = MKPointAnnotation()
                annotation.coordinate = annotationToPopulate.coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
}

//MARK: - Dog Mini Collection View
extension WalksOverviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func updateCollectionWithParticipatingDogs() {
        miniCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participatedDogsForWalk?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogMiniCollectionViewCell", for: indexPath) as! DogMiniCollectionViewCell
        if let dog = participatedDogsForWalk?[indexPath.row] {
            let cellImage = UIImage(data: dog.profile)
            cell.dogImage.image = cellImage
        }
        return cell
    }
    
    
}

