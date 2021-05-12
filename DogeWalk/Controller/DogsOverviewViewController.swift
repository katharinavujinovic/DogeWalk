//
//  DogsTableViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import RealmSwift

class DogsOverviewViewController: UIViewController {
    
    @IBOutlet weak var dogOverviewTableView: UITableView!
    @IBOutlet weak var walkButton: UIButton!
    
    @IBOutlet weak var addDogLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    let realm = try! Realm()
    let converter = Converter()
    
    var selectedDog: Dog?
    var dogs: Results<Dog>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadDogs()
        if dogs != nil {
            arrowImage.isHidden = true
            addDogLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nib registration
        let nib = UINib(nibName: "DogOverviewTableViewCell", bundle: nil)
        dogOverviewTableView.register(nib, forCellReuseIdentifier: "DogOverviewTableViewCell")
        // delegation assigning
        dogOverviewTableView.dataSource = self
        dogOverviewTableView.delegate = self
    }

    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.dogOverviewToPreWalk, sender: self)
    }

    func loadDogs() {
        dogs = realm.objects(Dog.self)
        DispatchQueue.main.async {
            self.dogOverviewTableView.reloadData()
        }
    }
    
    /*
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "participatingDogs")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            let fetchedDogs = fetchedResultsController.fetchedObjects
            for dog in fetchedDogs! {
                dogs.append(dog)
            }
        } catch {
            print("fetch could not been done")
        }
        DispatchQueue.main.async {
            self.dogOverviewTableView.reloadData()
        }
    }
 */
    
    func setbackgroundTint(_ cell: DogOverviewTableViewCell, colorOne: UIColor, colorTwo: UIColor) {
        cell.backgroundTint.setGradientViewBackground(colorOne: colorOne, colorTwo: colorTwo, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
}

//MARK: - TableView Controller
extension DogsOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogOverviewTableViewCell") as! DogOverviewTableViewCell
        if let aDog = dogs?[indexPath.row] {
            cell.dogImage.image = UIImage(data: aDog.profile)
            if aDog.age != nil {
                cell.ageLabel.text = converter.yearsBetweenDate(startDate: aDog.age!, endDate: Date())
            }
            cell.breedLabel.text = aDog.breed
            cell.nameLabel.text = aDog.name
            cell.toyLabel.text = aDog.favouriteToy
            cell.treatLabel.text = aDog.favouriteTreat
            
            if aDog.isFemale == true {
                setbackgroundTint(cell, colorOne: #colorLiteral(red: 0.9803921569, green: 0.537254902, blue: 0.4823529412, alpha: 1), colorTwo: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.5803921569, alpha: 1))
            } else {
                setbackgroundTint(cell, colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.6470588235, alpha: 1))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDog = dogs?[indexPath.row]
        self.performSegue(withIdentifier: Constants.Segue.dogOverviewToDetail, sender: self)
    }
    
    //MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.dogOverviewToDetail {
            let dogDetailVC = segue.destination as! DogDetailViewController
            dogDetailVC.dog = selectedDog
        }
    }

}
