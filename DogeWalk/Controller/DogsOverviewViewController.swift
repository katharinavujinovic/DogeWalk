//
//  DogsTableViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import CoreData

class DogsOverviewViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var dogOverviewTableView: UITableView!
    @IBOutlet weak var walkButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Dog>!
    var selectedDog: Dog?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFetchedResultsController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DogOverviewTableViewCell", bundle: nil)
        dogOverviewTableView.register(nib, forCellReuseIdentifier: "DogOverviewTableViewCell")
        dogOverviewTableView.dataSource = self
        dogOverviewTableView.delegate = self
    }

    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.dogOverviewToPreWalk, sender: self)
    }

    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "participatingDogs")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetch could not been done")
        }
        DispatchQueue.main.async {
            self.dogOverviewTableView.reloadData()
        }
    }
    
    fileprivate func setbackgroundTint(_ cell: DogOverviewTableViewCell, colorOne: UIColor, colorTwo: UIColor) {
        cell.backgroundTint.setGradientViewBackground(colorOne: colorOne, colorTwo: colorTwo, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
}

//MARK: - TableView Controller
extension DogsOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aDog = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogOverviewTableViewCell") as! DogOverviewTableViewCell
        cell.dogImage.image = UIImage(data: aDog.profile!)
        cell.ageLabel.text = "\(aDog.age)"
        cell.breedLabel.text = aDog.breed
        cell.nameLabel.text = aDog.name
        cell.toyLabel.text = aDog.favouriteToy
        cell.treatLabel.text = aDog.favouriteTreat
        
        if aDog.gender == "female" {
            setbackgroundTint(cell, colorOne: #colorLiteral(red: 0.9803921569, green: 0.537254902, blue: 0.4823529412, alpha: 1), colorTwo: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.5803921569, alpha: 1))
        } else {
            setbackgroundTint(cell, colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.6470588235, alpha: 1))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDog = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: Constants.Segue.dogOverviewToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.dogOverviewToDetail {
            let dogDetailVC = segue.destination as! DogDetailViewController
            dogDetailVC.dog = selectedDog
        }
    }

}
