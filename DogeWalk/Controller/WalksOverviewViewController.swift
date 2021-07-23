//
//  WalksTableViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import RealmSwift
import MapKit

class WalksOverviewViewController: UIViewController {
    
    @IBOutlet weak var walkOverviewTableView: UITableView!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var addWalkStack: UIStackView!
    
    let realm = try! Realm()
    let converter = Converter()
    let defaults = UserDefaults.standard
    
    fileprivate var walks = [Walk]()
    var selectedWalk: Walk?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("ViewWillAppear triggered")
        loadWalks()
        if walks.count != 0 {
            addWalkStack.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nib registration
        let nib = UINib(nibName: Constants.Nibs.walkOverviewTableViewCell, bundle: nil)
        walkOverviewTableView.register(nib, forCellReuseIdentifier: Constants.Nibs.walkOverviewTableViewCell)
        // delegation assigning
        walkOverviewTableView.dataSource = self
        walkOverviewTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        self.walkOverviewTableView.reloadData()
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.walkOverviewToPrewalk, sender: self)
    }
    
    func loadWalks() {
        let allDogsResult = realm.objects(Dog.self)
        let allDogs = realmDogResultToArray(realmResult: allDogsResult)
        
        let stringNamesOfFilteredDogs = defaults.string(forKey: "dogFilter")
        let arrayNamesOfFilteredDogs = stringNamesOfFilteredDogs?.components(separatedBy: ", ")

        if allDogs.count == arrayNamesOfFilteredDogs?.count {
            let walksResult = realm.objects(Walk.self).sorted(byKeyPath: defaults.string(forKey: "sortBy") ?? "startDate", ascending: defaults.bool(forKey: "ascend"))
            walks = realmWalkResultToArray(realmResult: walksResult)
        } else {
            let filteredDogs = fetchFilteredDogs(arrayOfDogNames: arrayNamesOfFilteredDogs!, allDogs: allDogs)
            walks = walksForFetchedDogs(filteredDogs: filteredDogs)
        }
        walkOverviewTableView.reloadData()
    }
    
}

//MARK: - TableView Controller
extension WalksOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dogPerWalk: [Dog] = []
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.walkOverviewTableViewCell) as! WalksOverviewTableViewCell
        let aWalk = walks[indexPath.row]
            cell.dateLabel.text = converter.startTime(date: aWalk.startDate)
            cell.distancelabel.text = converter.displayDistance(meter: aWalk.distance)
            cell.startTimeLabel.text = converter.dayFormatter(date: aWalk.startDate)
            cell.timeLabel.text = converter.displayTime(seconds: aWalk.time)

            cell.mapView.removeAnnotations(cell.mapView.annotations)
            
            for dog in aWalk.participatedDogs {
                dogPerWalk.append(dog)
            }
            cell.participatedDogsForWalk = dogPerWalk
            

                if let unarchivedWalk = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [CLLocation.self], from: aWalk.route) as? [CLLocation] {
                    cell.mapView.addOverlay(createPolyLine(locations: unarchivedWalk))
                    let viewRegion = MKCoordinateRegion(center: unarchivedWalk[0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    cell.mapView.setRegion(viewRegion, animated: true)
                }
            if let unarchivedPoopAnnotation = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [CLLocation.self], from: aWalk.poopAnnotation) as? [CLLocation] {
                DispatchQueue.main.async {
                    cell.poopAnnotation = unarchivedPoopAnnotation
                    cell.populateMapViewWithAnnotations(iconToPopulate: "poopAnnotation")
                }
            }
            if let unarchivedPeeAnnotation = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [CLLocation.self], from: aWalk.peeAnnotation) as? [CLLocation] {
                    cell.peeAnnotation = unarchivedPeeAnnotation
                    cell.populateMapViewWithAnnotations(iconToPopulate: "peeAnnotation")
            }
            cell.updateCollectionWithParticipatingDogs()
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWalk = walks[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.walkOverviewToDetail, sender: self)
    }
    
    //MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.walkOverviewToDetail {
            let walkDetailVC = segue.destination as! WalkDetailViewController
            walkDetailVC.walk = selectedWalk
        }
        if segue.identifier == Constants.Segue.walkToFilter {
            let filterVC = segue.destination as! WalkSortingViewController
            filterVC.walksOverViewController = self
        }
    }
}
