//
//  ViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

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
    
    let locationManager = CLLocationManager()
    var userLocations: [CLLocation] = []
    var secondCounter = 0
    var passedTime = "0:0:0"
    var meterCount = 0.0
    var timer = Timer()
    var dogs: [Dog]!
    var startTime = ""
    var now: Date?
    
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
        print(dogs!)
        enableButton(play: true, pause: false, stop: false)
    }

    // start the distance and time tracking
    @IBAction func playButtonPressed(_ sender: Any) {
        selectDogsButton.hidesBackButton = true
        pressPlayLabel.isHidden = true
        enableButton(play: false, pause: true, stop: true)
        buttonReaction(play: true, pause: false, stop: false)
        // set the startTime
        if startTime == "" {
            now = Date()
            startTime = startTime(date: now!)
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
    func displayTime(seconds:Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
      return ("\(h):\(m):\(s)")
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func updateTimer() {
        secondCounter = secondCounter + 1
        passedTime = displayTime(seconds: secondCounter)
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


//MARK: - Archive
    
    func archiveWalk() {
        let newWalk = Walk(context: DataController.shared.viewContext)
        newWalk.date = Date()
        let kmCount = meterCount/1000
        newWalk.distance = String(format: "%.2f", kmCount)
        newWalk.route = userLocations
        newWalk.startTime = startTime
        newWalk.time = passedTime
        for dog in dogs {
            newWalk.addToParticipatingDogs(dog)
        }
        DataController.shared.saveViewContext()
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
            let kmCount = meterCount/1000
            distanceLabel.text = String(format: "%.2f", kmCount)
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

}

//MARK: - Mini CollectionView
extension CurrentWalkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniCell", for: indexPath) as! MiniCollectionViewCell
        let cellImage = UIImage(data: dogs[indexPath.row].profile!)
        cell.miniImage.image = cellImage
        return cell
    }
    
}
