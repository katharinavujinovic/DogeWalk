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
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Walk>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkOverviewTableView.dataSource = self
        walkOverviewTableView.delegate = self
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        let newWalkViewController = storyboard?.instantiateViewController(identifier: Constants.Segue.dogOverviewToPreWalk) as! PreWalkViewController
        present(newWalkViewController, animated: true, completion: nil)
    }
    
    // if there are no walks yet, there should be an image stating that
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? WalksOverviewTableViewCell else {return}
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let walkDetailViewController = storyBoard.instantiateViewController(identifier: Constants.Segue.walkOverviewToDetail) as! WalkDetailViewController
        walkDetailViewController.walk = fetchedResultsController.object(at: indexPath)
        present(walkDetailViewController, animated: true, completion: nil)
    }
}


extension WalksOverviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nSSetDogs = fetchedResultsController.object(at: indexPath).value(forKey: "participatingDogs") as! [Dog]
        
        var dogImages: [UIImage] = []
        for dog in nSSetDogs {
            let image = UIImage(data: dog.profile!)
            dogImages.append(image!)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniCollectionViewCell", for: indexPath) as! MiniCollectionViewCell
        cell.dogImage.image = dogImages[indexPath.row]
        return cell
    }
}
