//
//  WalksTableViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import CoreData

class WalksOverviewViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var walkOverviewTableView: UITableView!
    @IBOutlet weak var walkButton: UIButton!
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Walk>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        // segue into PreWalkViewController IF there are more than 1 dog. If there is only one dog, segue into CurrentWalkViewController
    }
    // displays all the walks you have done with your dog/dogs sorted from recent to oldest
    
    // if there are no walks yet, there should be an image stating that
    
    // if one walk is pressed, segue to the WalksDetailViewController
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "walks")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetch could not been done")
        }
    }
    
}

extension WalksOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aWalk = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalksOverviewTableViewCell") as! WalksOverviewTableViewCell
        cell.dateLabel.text = "\(String(describing: aWalk.date))"
        cell.distancelabel.text = aWalk.distance
        cell.startTimeLabel.text = aWalk.startTime
        cell.timeLabel.text = aWalk.time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let walkDetailViewController = storyBoard.instantiateViewController(identifier: Constants.Segue.walkOverviewToDetail) as! WalkDetailViewController
        walkDetailViewController.walk = fetchedResultsController.object(at: indexPath)
        present(walkDetailViewController, animated: true, completion: nil)
    }
}
