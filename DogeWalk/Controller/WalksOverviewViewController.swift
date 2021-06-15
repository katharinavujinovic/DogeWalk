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
    
    let realm = try! Realm()
    let converter = Converter()
    
    var walks: Results<Walk>?
    var selectedWalk: Walk?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadWalks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nib registration
        let nib = UINib(nibName: "WalksOverviewTableViewCell", bundle: nil)
        walkOverviewTableView.register(nib, forCellReuseIdentifier: "WalksOverviewTableViewCell")
        // delegation assigning
        walkOverviewTableView.dataSource = self
        walkOverviewTableView.delegate = self
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.walkOverviewToPrewalk, sender: self)
    }
    
    func loadWalks() {
        walks = realm.objects(Walk.self).sorted(byKeyPath: "startDate", ascending: true)
        DispatchQueue.main.async {
            self.walkOverviewTableView.reloadData()
        }
    }
    
}

//MARK: - TableView Controller
extension WalksOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalksOverviewTableViewCell") as! WalksOverviewTableViewCell
        if let aWalk = walks?[indexPath.row] {
            cell.dateLabel.text = converter.startTime(date: aWalk.startDate)
            cell.distancelabel.text = converter.displayDistance(meter: aWalk.distance)
            cell.startTimeLabel.text = converter.dayFormatter(date: aWalk.startDate)
            cell.timeLabel.text = converter.displayTime(seconds: aWalk.time)

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
            
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWalk = walks?[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.walkOverviewToDetail, sender: self)
    }
    
    //MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.walkOverviewToDetail {
            let walkDetailVC = segue.destination as! WalkDetailViewController
            walkDetailVC.walk = selectedWalk
        }
    }
}

