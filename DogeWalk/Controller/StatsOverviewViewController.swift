//
//  StatsOverviewViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 16.06.21.
//

import Foundation
import UIKit
import RealmSwift

class StatsOverviewViewController: UIViewController {
    
    @IBOutlet weak var dogSelectionCollectionView: UICollectionView!
    @IBOutlet weak var statTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let realm = try! Realm()
    
    var dogs: Results<Dog>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDogs()
        let nib = UINib(nibName: "DogSelectionCollectionViewCell", bundle: nil)
        dogSelectionCollectionView.register(nib, forCellWithReuseIdentifier: "DogSelectionCollectionViewCell")
        dogSelectionCollectionView.dataSource = self
        dogSelectionCollectionView.delegate = self
    }
    
    @IBAction func walkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.walkOverviewToPrewalk, sender: self)
    
    }
    
    func loadDogs() {
        dogs = realm.objects(Dog.self)
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
