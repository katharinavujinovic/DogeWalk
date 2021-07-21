//
//  WalkSortingViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 20.07.21.
//

import Foundation
import UIKit
import RealmSwift

class WalkSortingViewController: UIViewController {
    
    @IBOutlet weak var sortAndFilterTableView: UITableView!
    
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortingNib = UINib(nibName: Constants.Nibs.walkSortingTableViewCell, bundle: nil)
        let filteringNib = UINib(nibName: Constants.Nibs.dogFilterTableViewCell, bundle: nil)
        sortAndFilterTableView.register(sortingNib, forCellReuseIdentifier: Constants.Nibs.walkSortingTableViewCell)
        sortAndFilterTableView.register(filteringNib, forCellReuseIdentifier: Constants.Nibs.dogFilterTableViewCell)
        sortAndFilterTableView.delegate = self
        sortAndFilterTableView.dataSource = self
    }
    
    @IBAction func resetPressed(_ sender: Any) {
    // reset to default -> sort by date & all dogs
    // dismiss view
        defaults.set("startDate", forKey: "sortBy")
        defaults.set(false, forKey: "ascend")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
    // save the sort/filter preference
    // dismiss view
        self.dismiss(animated: true, completion: nil)
    
    }
    
}

extension WalkSortingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //show the sorting option
            // sorting cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.walkSortingTableViewCell, for: indexPath) as! WalkSortingTableViewCell
                
            return cell
        } else {
            // shor filter option
            // collectionView with your dogs
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.dogFilterTableViewCell, for: indexPath) as! DogFilterTableViewCell
            cell.dogs = realm.objects(Dog.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sorting by"
        } else {
            return "Filtering by"
        }
    }
    
    
}
