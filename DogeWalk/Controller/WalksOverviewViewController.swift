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
        walks = realm.objects(Walk.self)
        DispatchQueue.main.async {
            self.walkOverviewTableView.reloadData()
        }
    }
    
    /*
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "participatedWalks")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetch could not been done")
        }
        DispatchQueue.main.async {
            self.walkOverviewTableView.reloadData()
        }
    }
 */
    
}

//MARK: - TableView Controller
extension WalksOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalksOverviewTableViewCell") as! WalksOverviewTableViewCell
        if let aWalk = walks?[indexPath.row] {
            cell.dateLabel.text = timeFormatter(date: aWalk.date!)
            cell.distancelabel.text = aWalk.distance
            cell.startTimeLabel.text = aWalk.startTime
            cell.timeLabel.text = aWalk.time
            let locations = aWalk.route!
            cell.mapView.addOverlay(createPolyLine(locations: locations))
            let viewRegion = MKCoordinateRegion(center: aWalk.route![0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            cell.mapView.setRegion(viewRegion, animated: true)
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

