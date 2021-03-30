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
