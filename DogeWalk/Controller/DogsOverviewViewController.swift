//
//  DogsTableViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit

class DogsOverviewViewController: UIViewController {
    
    @IBOutlet weak var dogOverviewTableView: UITableView!
    @IBOutlet weak var newDogButton: UIBarButtonItem!
    @IBOutlet weak var walkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func newDogButtonPressed(_ sender: Any) {
        // segue to EditDogViewController
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        // segue into PreWalkViewController IF there are more than 1 dog. If there is only one dog, segue into CurrentWalkViewController
    }
    
    // Has a TableView with all the current dogs!
    
    // if one of the cells is tapped, a segue to the DogDetailViewcontroller will open up
}
