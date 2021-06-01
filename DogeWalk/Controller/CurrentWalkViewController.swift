//
//  ViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class CurrentWalkViewController: UIViewController {
    
    @IBOutlet weak var selectDogsButton: UINavigationItem!
    @IBOutlet weak var currentWalkMapView: MKMapView!
    @IBOutlet weak var miniCollectionView: UICollectionView!

    // Play/Pause/Stop
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopImage: UIImageView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pressPlayLabel: UILabel!
    // Walkstats
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // Floating Button to add annotations
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var poopButton: UIButton!
    @IBOutlet weak var peeButton: UIButton!
    @IBOutlet weak var expandableStack: UIStackView!
    @IBOutlet weak var containerStack: UIStackView!
    
    let realm = try! Realm()
    let converter = Converter()
    
    let locationManager = CLLocationManager()
    var userLocations: [CLLocation] = []
    var secondCounter = 0
    var meterCount = 0.0
    var timer = Timer()
    var dogs: [Dog]!
    var startTime: Date?
    var now: Date?
    private var selectedIcon: String?
    var peeAnnotations: [CLLocation] = []
    var poopAnnotations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        currentWalkMapView.delegate = self
        miniCollectionView.delegate = self
        miniCollectionView.dataSource = self
        miniCollectionView.backgroundColor = .clear
        currentWalkMapView.mapType = MKMapType(rawValue: 0)!
        currentWalkMapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        enableButton(play: true, pause: false, stop: false)
        setFloatingButton()
        distanceLabel.text = converter.displayDistance(meter: meterCount)
    }

    // start the distance and time tracking
    @IBAction func playButtonPressed(_ sender: Any) {
        selectDogsButton.hidesBackButton = true
        pressPlayLabel.isHidden = true
        enableButton(play: false, pause: true, stop: true)
        buttonReaction(play: true, pause: false, stop: false)
        // set the startTime
        if startTime == nil {
            startTime = Date()
        }
        // start the Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        buttonReaction(play: false, pause: true, stop: false)
        enableButton(play: true, pause: false, stop: true)
        stopLocationUpdate()
        timer.invalidate()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        buttonReaction(play: false, pause: false, stop: true)
        enableButton(play: false, pause: false, stop: false)
        stopLocationUpdate()
        timer.invalidate()
        let alert = UIAlertController(title: "Do you want to end the walk?", message: "By confirming, you walk will be ended and saved", preferredStyle: .alert)
        let savingAction = UIAlertAction(title: "Stop and Save", style: .default) { (action: UIAlertAction) in
            self.archiveWalk()
        }
        let continueAction = UIAlertAction(title: "Continue Walk", style: .default) { (action: UIAlertAction) in
            self.enableButton(play: false, pause: true, stop: true)
            self.buttonReaction(play: true, pause: false, stop: false)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
        
        alert.addAction(savingAction)
        alert.addAction(continueAction)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Timer
    @objc func updateTimer() {
        secondCounter = secondCounter + 1
        let passedTime = converter.displayTime(seconds: secondCounter)
        timeLabel.text = passedTime
    }
    
//MARK: - Button UI
    fileprivate func buttonReaction(play: Bool, pause: Bool, stop: Bool) {
        playImage.isHighlighted = play
        pauseImage.isHighlighted = pause
        stopImage.isHighlighted = stop
    }
    
    fileprivate func enableButton(play: Bool, pause: Bool, stop: Bool) {
        playButton.isEnabled = play
        pauseButton.isEnabled = pause
        stopButton.isEnabled = stop
    }
    
    fileprivate func setFloatingButton() {
        buttonView.layer.cornerRadius = addButton.frame.width / 2
        addButton.layer.cornerRadius = addButton.frame.width / 2
        poopButton.layer.cornerRadius = poopButton.frame.width / 2
        peeButton.layer.cornerRadius = peeButton.frame.width / 2
    }


//MARK: - Archive
    
    func archiveWalk() {
        do {
            try realm.write {
                let newWalk = Walk()
                newWalk.startDate = startTime!
                newWalk.distance = meterCount
                newWalk.time = secondCounter
                for dog in dogs {
                    dog.participatedWalks.append(newWalk)
                }
                do {
                    let locationData = try NSKeyedArchiver.archivedData(withRootObject: userLocations as Array, requiringSecureCoding: false)
                    newWalk.route = locationData
                } catch {
                    print("Error with transforming userlocation to data, \(error)")
                }
                if peeAnnotations != [] {
                    newWalk.peeAnnotation = try NSKeyedArchiver.archivedData(withRootObject: peeAnnotations, requiringSecureCoding: false)
                }
                if poopAnnotations != [] {
                    newWalk.poopAnnotation = try NSKeyedArchiver.archivedData(withRootObject: poopAnnotations, requiringSecureCoding: false)
                }
                realm.add(newWalk)
            }
        } catch {
            print("Walk could not be saved, \(error)")
        }
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - Floating Button
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let willExpand = expandableStack.isHidden
        let addButtonTitle = willExpand ? "x" : "+"
        UIView.animate(
            withDuration: 0.3, delay: 0, options: .curveEaseIn,
            animations: {
              self.expandableStack.subviews.forEach { $0.isHidden = !$0.isHidden }
              self.expandableStack.isHidden = !self.expandableStack.isHidden
                if willExpand {
                          self.addButton.setTitle(addButtonTitle, for: .normal)
                        }
            }
            , completion: { _ in
                  if !willExpand {
                    self.addButton.setTitle(addButtonTitle, for: .normal)
                  }
                }
        )
    }
    
    @IBAction func poopButtonPressed(_ sender: Any) {
        selectedIcon = "poopButton"
        let annotation = MKPointAnnotation()
        if userLocations != [] {
            let lastLocation = userLocations.last!
            annotation.coordinate = lastLocation.coordinate
            poopAnnotations.append(lastLocation)
            currentWalkMapView.addAnnotation(annotation)
        } else {
            print("There are no locationpoints yet in userLocations!")
        }
    }
    
    @IBAction func peeButtonPressed(_ sender: Any) {
        selectedIcon = "peeButton"
        let annotation = MKPointAnnotation()
        if userLocations != [] {
            let lastLocation = userLocations.last!
            annotation.coordinate = lastLocation.coordinate
            peeAnnotations.append(lastLocation)
            currentWalkMapView.addAnnotation(annotation)
        } else {
            print("There are no locationpoints yet in userLocations!")
        }
    }
    
}
//MARK: - MapKit Extension

extension CurrentWalkViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    // is called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentUserLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: currentUserLocation!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        // needs to count the distance from oldLocation to newLocation here
        if userLocations != [] {
            let distanceInMeters = currentUserLocation?.distance(from: userLocations.last!)
            meterCount = meterCount + distanceInMeters!
            distanceLabel.text = converter.displayDistance(meter: meterCount)
        }
        self.userLocations.append(currentUserLocation!)
        currentWalkMapView.addOverlay(createPolyLine(locations: userLocations))
        currentWalkMapView.setRegion(viewRegion, animated: true)
    }
    
    // This specifies how the map reads the polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1)
            polyLineRenderer.lineWidth = 5
            return polyLineRenderer
        }
        return MKOverlayRenderer()
    }
    
//MARK: - MapKit Annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if selectedIcon == "poopButton" {
            let reuseId = "poopPin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.image = #imageLiteral(resourceName: "PoopAnnotation")
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        } else if selectedIcon == "peeButton" {
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
}

//MARK: - Mini CollectionView
extension CurrentWalkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniCell", for: indexPath) as! MiniCollectionViewCell
            let cellImage = UIImage(data: dogs[indexPath.row].profile)
            cell.miniImage.image = cellImage
        return cell
    }
    
}
