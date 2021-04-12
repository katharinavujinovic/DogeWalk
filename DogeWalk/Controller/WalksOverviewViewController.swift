//
//  WalksTableViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import CoreData
import MapKit

class WalksOverviewViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var walkOverviewTableView: UITableView!
    @IBOutlet weak var walkButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Walk>!
    var selectedWalk: Walk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "WalksOverviewTableViewCell", bundle: nil)
        walkOverviewTableView.register(nib, forCellReuseIdentifier: "WalksOverviewTableViewCell")
        setupFetchedResultsController()
        walkOverviewTableView.dataSource = self
        walkOverviewTableView.delegate = self
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.walkOverviewToPrewalk, sender: self)
    }
    
    // if there are no walks yet, there should be an image stating that
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
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
    
    func createPolyLine(locations: [CLLocation]) -> MKPolyline {
        let coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        let polyLine = MKPolyline(coordinates: coordinates, count: locations.count)
        return polyLine
    }
}

//MARK: - TableView Controller
extension WalksOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aWalk = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalksOverviewTableViewCell") as! WalksOverviewTableViewCell
        cell.dateLabel.text = "\(String(describing: aWalk.date))"
        cell.distancelabel.text = aWalk.distance
        cell.startTimeLabel.text = aWalk.startTime
        cell.timeLabel.text = aWalk.time
        let locations = aWalk.route!
        cell.mapView.addOverlay(createPolyLine(locations: locations))
        let viewRegion = MKCoordinateRegion(center: aWalk.route![0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        cell.mapView.setRegion(viewRegion, animated: true)
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWalk = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: Constants.Segue.walkOverviewToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.walkOverviewToDetail {
            let walkDetailVC = segue.destination as! WalkDetailViewController
            walkDetailVC.walk = selectedWalk
        }
    }
}

