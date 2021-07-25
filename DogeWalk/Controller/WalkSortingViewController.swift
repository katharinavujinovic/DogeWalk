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
    var walksOverViewController: WalksOverviewViewController!
    let walkSorting = WalkSorting()
    
    var sortingOptions = ["Distance", "Date", "Duration"]
    var selectedItem: String?
    var isAscending: Bool?
    var filteredDogs: [Dog]?
    var allDogs: Results<Dog>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allDogs = realm.objects(Dog.self)
        let sortingNib = UINib(nibName: Constants.Nibs.sortingTableViewCell, bundle: nil)
        let filteringNib = UINib(nibName: Constants.Nibs.dogFilterTableViewCell, bundle: nil)
        sortAndFilterTableView.register(sortingNib, forCellReuseIdentifier: Constants.Nibs.sortingTableViewCell)
        sortAndFilterTableView.register(filteringNib, forCellReuseIdentifier: Constants.Nibs.dogFilterTableViewCell)
        sortAndFilterTableView.delegate = self
        sortAndFilterTableView.dataSource = self
        
        let filteringRowToSelect = IndexPath(row: walkSorting.sortingCellIsSelected(), section: 0)
        self.sortAndFilterTableView.selectRow(at: filteringRowToSelect, animated: true, scrollPosition: .none)
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        defaults.set("startDate", forKey: "sortBy")
        defaults.set(false, forKey: "ascend")
        
        if let nonOptionalAllDogs = allDogs {
            walkSorting.changeAllDogsValue(select: true, allDogs: nonOptionalAllDogs)
        }
        walksOverViewController.loadWalks()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if let newSortingDefault = selectedItem {
            defaults.set(newSortingDefault, forKey: "sortBy")
        }
        if let newAscendDefault = isAscending {
            defaults.set(newAscendDefault, forKey: "ascend")
        }
        
        if filteredDogs != nil {
            defaults.setValue(filteredDogs!.count, forKey: "numberOfFilteredDogs")
            if let unwrappedAllDogs = allDogs {
                walkSorting.changeAllDogsValue(select: false, allDogs: unwrappedAllDogs)
            }
            walkSorting.changeDogSelectionValue(select: true, changeDogs: filteredDogs!)
        } else {
            if let unwrappedAllDogs = allDogs {
                defaults.setValue(nil, forKey: "numberOfFilteredDogs")
                walkSorting.changeAllDogsValue(select: true, allDogs: unwrappedAllDogs)
            }
        }
        walksOverViewController.loadWalks()
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITableView
extension WalkSortingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sortingOptions.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.sortingTableViewCell, for: indexPath) as! SortingTableViewCell
            cell.sortingLabel.text = sortingOptions[indexPath.row]
            cell.delegate = self
            cell.isAscending = !defaults.bool(forKey: "ascend")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.dogFilterTableViewCell, for: indexPath) as! DogFilterTableViewCell
            cell.dogs = allDogs
            cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItemFromTableView = sortingOptions[indexPath.row]
        switch selectedItemFromTableView {
            case "Distance":
                selectedItem = "distance"
            case "Date":
                selectedItem = "startDate"
            case "Duration":
                selectedItem = "time"
            default:
                break
            }
    }
}

extension WalkSortingViewController: PassAscendingValueDelegate {
    func passAscendingValue(_ data: Bool?) {
        isAscending = data
    }
}

extension WalkSortingViewController: PassSelectedDogsDelegate {
    func passSelectedDogsData(_ data: [Dog]?) {
        filteredDogs = data
    }
}
