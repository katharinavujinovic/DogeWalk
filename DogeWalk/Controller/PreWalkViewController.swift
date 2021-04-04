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
    
    @IBOutlet weak var preWalkCollectionViewController: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Dog>!
    var selectedDogs: [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContinueButton()
        setupFetchedResultsController()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        let currentwalkViewController = storyboard?.instantiateViewController(identifier: Constants.Segue.preWalkToCurrentWalk) as! CurrentWalkViewController
        currentwalkViewController.dogs = selectedDogs
        present(currentwalkViewController, animated: true, completion: nil)
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
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "dogs")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetch could not been done")
        }
    }
    
}

//MARK: - Dog Selection CollectionView
extension PreWalkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aDog = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogSelectionCollectionViewCell", for: indexPath) as! DogSelectionCollectionViewCell
        cell.dogImage.image = UIImage(data: aDog.profile!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aDog = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogSelectionCollectionViewCell", for: indexPath) as! DogSelectionCollectionViewCell
        // select and deselect!
        if cell.selectionView.alpha == 0.5 {
            cell.selectionView.alpha = 1
            selectedDogs.append(aDog)
        } else if cell.selectionView.alpha == 1 {
            cell.selectionView.alpha = 0.5
            if let index = selectedDogs.firstIndex(of: aDog) {
                selectedDogs.remove(at: index)
            }
        }
    }
}
