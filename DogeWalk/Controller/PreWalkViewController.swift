//
//  SelectDogsPreWalkViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import CoreData

class PreWalkViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var preWalkCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var selectDogLabel: UILabel!
    
    var fetchedResultsController: NSFetchedResultsController<Dog>!
    var selectedDogs: [Dog] = []
    var fetchedDogs: [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        let nib = UINib(nibName: "DogSelectionCollectionViewCell", bundle: nil)
        preWalkCollectionView.register(nib, forCellWithReuseIdentifier: "DogSelectionCollectionViewCell")
        preWalkCollectionView.dataSource = self
        preWalkCollectionView.delegate = self
        preWalkCollectionView.allowsMultipleSelection = true
        setContinueButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if fetchedDogs == [] {
            presentAlarm()
        }
        preWalkCollectionView.reloadData()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        if selectedDogs == [] {
        let currentwalkViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.Segue.preWalkToCurrentWalk) as! CurrentWalkViewController
        currentwalkViewController.dogs = selectedDogs
        present(currentwalkViewController, animated: true, completion: nil)
        } else {
            selectDogLabel.textColor = .red
        }
    }
    
    fileprivate func setContinueButton() {
        // set the button to have a gradient and rounded corners
        continueButton.layer.cornerRadius = 15
        continueButton.clipsToBounds = true
        continueButton.setGradientBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "dogs")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            if let fetchedResults = fetchedResultsController.fetchedObjects {
                for fetchedDogResult in fetchedResults {
                    fetchedDogs.append(fetchedDogResult)
                }
            }
        } catch {
            print("fetch could not been done")
        }
    
        DispatchQueue.main.async {
            self.preWalkCollectionView.reloadData()
        }
    }
    
    func presentAlarm() {
        let alert = UIAlertController(title: "No Dog registered yet", message: "Make sure to create a profile for your dog before going for a walk", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Dog Selection CollectionView
extension PreWalkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.frame.width - 8) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedDogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogSelectionCollectionViewCell", for: indexPath) as! DogSelectionCollectionViewCell
        let cellImage = UIImage(data: fetchedDogs[indexPath.row].profile!)
        cell.dogImage.image = cellImage
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aDog = fetchedDogs[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogSelectionCollectionViewCell", for: indexPath) as! DogSelectionCollectionViewCell
        if cell.isSelected == true {
            cell.isSelected = false
            if let index = selectedDogs.firstIndex(of: aDog) {
                selectedDogs.remove(at: index)
            }
        } else {
            cell.isSelected = true
            selectedDogs.append(aDog)
        }
    }

}
