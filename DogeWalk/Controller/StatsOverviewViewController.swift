//
//  StatsOverviewViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 16.06.21.
//

import Foundation
import UIKit
import RealmSwift
import Charts

class StatsOverviewViewController: UIViewController {
    
    @IBOutlet weak var dogSelectionCollectionView: UICollectionView!
    @IBOutlet weak var statTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let realm = try! Realm()
    let today = Date()
    
    var dogs: Results<Dog>?
    var selectedDog: Dog?
    var walksByDog: Results<Walk>?
    var dateSpecificWalks: [Walk]?
    var legendForStatCell: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDogs()
        let dogNib = UINib(nibName: "DogSelectionCollectionViewCell", bundle: nil)
        dogSelectionCollectionView.register(dogNib, forCellWithReuseIdentifier: "DogSelectionCollectionViewCell")
        let statNib = UINib(nibName: "StatsTableViewCell", bundle: nil)
        statTableView.register(statNib, forCellReuseIdentifier: "StatsTableViewCell")
        dogSelectionCollectionView.dataSource = self
        dogSelectionCollectionView.delegate = self
        statTableView.dataSource = self
        statTableView.delegate = self
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.walkOverviewToPrewalk, sender: self)
    }
    
    func loadDogs() {
        dogs = realm.objects(Dog.self)
    }
    
    func loadWalksByDog() {
        walksByDog = selectedDog?.participatedWalks.sorted(byKeyPath: "startDate", ascending: true)
    }
    
    @IBAction func segmentControlPressed(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if walksByDog != nil {
                currentDayWalks(walks: walksByDog!)
            }
            // show daily stats
            print("daily selected")
        case 1:
            // show weekly stats
            print("weekly selected")
        case 2:
            // show monthly stats
            print("monthly selected")
        default:
            break
        }
    
    }
    
    func currentDayWalks(walks: Results<Walk>) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.timeStyle = .none
        
        for walk in walks {
            if timeFormatter.string(from: walk.startDate) == timeFormatter.string(from: today) {
                dateSpecificWalks?.append(walk)
                legendForStatCell.append(timeFormatter.string(from: walk.startDate))
            }
        }
    }
    
}

//MARK: - Dog SelectionCollectionView
extension StatsOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogSelectionCollectionViewCell", for: indexPath) as! DogSelectionCollectionViewCell
        if let dog = dogs?[indexPath.row] {
            let cellImage = UIImage(data: dog.profile)
            cell.dogImage.image = cellImage
            cell.dogName.text = dog.name
        }
        return cell
    }
}


//MARK: - StatTableView
// Pass the correct number of y values as your xvalues!
// Use: for _ in yValue.count..<xValue.count {
//      yValue.append(0.0)

// This way you will always have the same formatting!
extension StatsOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dateSpecificWalks != nil {
            return 1
        }
        //MARK: - still some fixing to be done!
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsTableViewCell") as! StatsTableViewCell
        // assign cell.axis!
        cell.xAxis = legendForStatCell
        
        return cell
    }
    
    
    
}
