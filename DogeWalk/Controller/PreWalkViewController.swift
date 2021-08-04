//
//  SelectDogsPreWalkViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import RealmSwift

class PreWalkViewController: UIViewController {
    
    @IBOutlet weak var preWalkCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var selectDogLabel: UILabel!
    
    let realm = DatabaseManager.realm
    
    var dogs: Results<Dog>?
    var selectedDogs: [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDogs()
        // nib registration
        let nib = UINib(nibName: Constants.Nibs.dogSelectionCollectionViewCell, bundle: nil)
        preWalkCollectionView.register(nib, forCellWithReuseIdentifier: Constants.Nibs.dogSelectionCollectionViewCell)
        // delegation assigning
        preWalkCollectionView.dataSource = self
        preWalkCollectionView.delegate = self
        preWalkCollectionView.allowsMultipleSelection = true
        // UI
        setContinueButton()
    }

    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        if selectedDogs == [] {
            selectDogLabel.textColor = .red
        } else {
            self.performSegue(withIdentifier: Constants.Segue.preWalkToCurrentWalk, sender: self)
        }
    }
    
    //MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.preWalkToCurrentWalk {
            let currentWalkVC = segue.destination as! CurrentWalkViewController
            currentWalkVC.dogs = selectedDogs
        }
    }
    
    fileprivate func setContinueButton() {
        continueButton.layer.cornerRadius = 15
        continueButton.clipsToBounds = true
        continueButton.setGradientBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
    fileprivate func loadDogs() {
        dogs = DatabaseManager.callResult(realm: realm, objectType: Dog.self)
        DispatchQueue.main.async {
            self.preWalkCollectionView.reloadData()
        }
        if dogs?.count == 0 {
            presentAlarm()
        }
    }
    
    func presentAlarm() {
        let alert = UIAlertController(title: Constants.AlertMessages.dogSelectionTitle, message: Constants.AlertMessages.dogSelectionMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .cancel, handler: { (alert) in
            self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Dog Selection CollectionView
extension PreWalkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Nibs.dogSelectionCollectionViewCell, for: indexPath) as! DogSelectionCollectionViewCell
        if let dog = dogs?[indexPath.row] {
            let cellImage = UIImage(data: dog.profile)
            cell.dogImage.image = cellImage
            cell.dogName.text = dog.name
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Nibs.dogSelectionCollectionViewCell, for: indexPath) as! DogSelectionCollectionViewCell
        if let aDog = dogs?[indexPath.row] {
            if cell.isSelected == true {
                selectedDogs.append(aDog)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Nibs.dogSelectionCollectionViewCell, for: indexPath) as! DogSelectionCollectionViewCell
        if let aDog = dogs?[indexPath.row] {
            if cell.isSelected == false {
                if let index = selectedDogs.firstIndex(of: aDog) {
                    selectedDogs.remove(at: index)
                }
            }
        }
    }
}
