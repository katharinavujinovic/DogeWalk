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
    
    @IBOutlet weak var currentWalkMapView: MKMapView!
    @IBOutlet weak var currentWalkCollectionView: UICollectionView!
    // Saving Indicators
    @IBOutlet weak var savingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var greatJobLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
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
    // NavigationBar
    @IBOutlet weak var backSelectDogs: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        enableButton(play: true, pause: false, stop: false)
    }
    
    
    // Dismiss this ViewController when select Dogs is pressed
    // backSelectDogs must be hidden during the run!
    @IBAction func backSelectDogsPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // start the distance and time tracking
    
    @IBAction func playButtonPressed(_ sender: Any) {
        pressPlayLabel.isHidden = true
        enableButton(play: false, pause: true, stop: true)
        buttonReaction(play: true, pause: false, stop: false)

    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        buttonReaction(play: false, pause: true, stop: false)
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        saveIndication()
        buttonReaction(play: false, pause: false, stop: true)
        // segue to WalkDetailController with the latest walk
    }

//MARK: - Location Service
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // show alert to let user know why they need to enable this
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            currentWalkMapView.showsUserLocation = true
        case.denied:
            // show alert to turn on locationservice
        break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            currentWalkMapView.showsUserLocation = true
        case .restricted:
            // show alert that locationusage is restricted
        break
        case .authorizedAlways:
            break
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
            currentWalkMapView.showsUserLocation = true
        }
    }
    
    
//MARK: - Button UI
    fileprivate func saveIndication() {
        savingIndicator.startAnimating()
        greatJobLabel.isHidden = true
        savingLabel.isHidden = true
    }
    
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
}

//MARK: - MapKit Extension

extension CurrentWalkViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    

}
