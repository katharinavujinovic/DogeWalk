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
    @IBOutlet weak var miniCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
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
    var userLocations: [CLLocation] = []
    var secondCounter = 0
    var passedTime = "0:0:0"
    var meterCount = 0.0
    var timer = Timer()
    var dogs: [Dog]!
    var startTime = ""
    var date = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        //        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        registerNib()
        locationManager.delegate = self
        currentWalkMapView.delegate = self
        miniCollectionView.delegate = self
        miniCollectionView.dataSource = self
        currentWalkMapView.mapType = MKMapType(rawValue: 0)!
        currentWalkMapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        print(dogs!)
        enableButton(play: true, pause: false, stop: false)
    }
    
    @IBAction func backSelectDogsPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // start the distance and time tracking
    @IBAction func playButtonPressed(_ sender: Any) {
        backSelectDogs.isEnabled = false
        pressPlayLabel.isHidden = true
        enableButton(play: false, pause: true, stop: true)
        buttonReaction(play: true, pause: false, stop: false)
        if startTime == "" {
            setTime()
        }
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
        saveIndication()
        buttonReaction(play: false, pause: false, stop: true)
        enableButton(play: false, pause: false, stop: false)
        stopLocationUpdate()
        timer.invalidate()
        archiveWalk()
        self.navigationController?.dismiss(animated: true, completion: nil)
        // segue to WalkDetailController with the latest walk
    }
    
    func setTime() {
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        date = dateFormatter.string(from: now)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        startTime = timeFormatter.string(from: now)
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
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
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
    fileprivate func saveIndication() {
        savingIndicator.startAnimating()
        greatJobLabel.isHidden = false
        savingLabel.isHidden = false
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


//MARK: - PolyLine Archive
    

    func archive(walk: Walk) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newEntity = NSEntityDescription.entity(forEntityName: "Walk", in: managedContext)!
        let newWalk = NSManagedObject(entity: newEntity, insertInto: managedContext)
        newWalk.setValue(walk.date, forKey: "date")
        newWalk.setValue(walk.distance, forKey: "distance")
//        newWalk.setValue(walk.route, forKey: "route")
        newWalk.setValue(walk.startTime, forKey: "startTime")
        newWalk.setValue(walk.time, forKey: "time")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    func archiveWalk() {
        let newWalk = Walk(context: DataController.shared.viewContext)
        newWalk.date = date
        newWalk.distance = "\(meterCount)"
        newWalk.route = createPolyLine(locations: userLocations)
        newWalk.startTime = startTime
        newWalk.time = passedTime
        for dog in dogs {
            newWalk.addToParticipatingDogs(dog)
        }
        DataController.shared.saveViewContext()
    }
    

    func polyLineToArchive(polyLine: MKPolyline) -> NSData {
        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: polyLine.pointCount)
        polyLine.getCoordinates(coordsPointer, range: NSMakeRange(0, polyLine.pointCount))
        var coords: [Dictionary<String, AnyObject>] = []
        for i in 0..<polyLine.pointCount {
            let latitude = NSNumber(value: coordsPointer[i].latitude)
            let longitude = NSNumber(value: coordsPointer[i].longitude)
            let coord = ["latitude": latitude, "longitude": longitude]
            coords.append(coord)
        }
        let polyLineData = try? NSKeyedArchiver.archivedData(withRootObject: coords, requiringSecureCoding: false)
        return polyLineData! as NSData
    }

    
}
//MARK: - MapKit Extension

extension CurrentWalkViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func createPolyLine(locations: [CLLocation]) -> MKPolyline {
        let coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        let polyLine = MKPolyline(coordinates: coordinates, count: locations.count)
        return polyLine
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellDimension = (collectionView.frame.height - 4)
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniCollectionViewCell", for: indexPath) as! MiniCollectionViewCell
        let cellImage = UIImage(data: dogs[indexPath.row].profile!)
        cell.dogImage.image = cellImage
        return cell
    }
    
    func registerNib() {
        let nib = UINib(nibName: MiniCollectionViewCell.nibName, bundle: nil)
        miniCollectionView.register(nib, forCellWithReuseIdentifier: MiniCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.miniCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let space: CGFloat = 2
            let size: CGFloat = miniCollectionView.frame.height - (2 * space)
            flowLayout.minimumLineSpacing = 2
            flowLayout.minimumInteritemSpacing = 2
            flowLayout.itemSize = CGSize(width: size, height: size)
        }
    }
    
}
