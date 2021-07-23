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
    
    var sortingOptions = ["Distance", "Date", "Duration"]
    var selectedItem: String?
    var isAscending: Bool?
    var filteredDogs: [Dog]?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortingNib = UINib(nibName: Constants.Nibs.sortingTableViewCell, bundle: nil)
        let filteringNib = UINib(nibName: Constants.Nibs.dogFilterTableViewCell, bundle: nil)
        sortAndFilterTableView.register(sortingNib, forCellReuseIdentifier: Constants.Nibs.sortingTableViewCell)
        sortAndFilterTableView.register(filteringNib, forCellReuseIdentifier: Constants.Nibs.dogFilterTableViewCell)
        sortAndFilterTableView.delegate = self
        sortAndFilterTableView.dataSource = self
        
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        defaults.set("startDate", forKey: "sortBy")
        defaults.set(false, forKey: "ascend")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if let newSortingDefault = selectedItem {
            defaults.set(newSortingDefault, forKey: "sortBy")
        }
        if let newAscendDefault = isAscending {
            defaults.set(newAscendDefault, forKey: "ascend")
        }
        if let unwrapfilteredDogs = filteredDogs {
            let numberOfAllDogs = realm.objects(Dog.self).count
            if unwrapfilteredDogs.count == 0 || unwrapfilteredDogs.count == numberOfAllDogs {
                return
            } else {
                var dogNames = [String]()
                for dog in unwrapfilteredDogs {
                    dogNames.append(dog.name)
                }
                let stringOfDogNames = dogNames.joined(separator: ", ")
                defaults.set(stringOfDogNames, forKey: "dogFilter")
            }
        }
        walksOverViewController.loadWalks()
        self.dismiss(animated: true, completion: nil)
    }
    
}

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
            let cellIsSelected = sortingCellIsSelected(labelOfCell: sortingOptions[indexPath.row])
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.sortingTableViewCell, for: indexPath) as! SortingTableViewCell
            cell.isSelected = cellIsSelected
            cell.sortingLabel.text = sortingOptions[indexPath.row]
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.dogFilterTableViewCell, for: indexPath) as! DogFilterTableViewCell
            cell.dogs = realm.objects(Dog.self)
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
