//
//  DogFilterTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 20.07.21.
//

import UIKit
import RealmSwift

class DogFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var dogFilterCollectionView: UICollectionView!
    
    let realm = try! Realm()
    //make a new request for all dogs
    var dogs: Results<Dog>?
    // make the WalkSortingVC listen to this value!
    var selectedDogs: [Dog] = []
    var delegate: PassSelectedDogsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: Constants.Nibs.dogSelectionCollectionViewCell, bundle: nil)
        dogFilterCollectionView.register(nib, forCellWithReuseIdentifier: Constants.Nibs.dogSelectionCollectionViewCell)
        dogFilterCollectionView.delegate = self
        dogFilterCollectionView.dataSource = self
        dogFilterCollectionView.allowsMultipleSelection = true
    }
    
}

extension DogFilterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        if let selectedDog = dogs?[indexPath.row] {
            if cell.isSelected == true {
                selectedDogs.append(selectedDog)
            }
            delegate?.passSelectedDogsData(selectedDogs)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Nibs.dogSelectionCollectionViewCell, for: indexPath) as! DogSelectionCollectionViewCell
        if let deselectedDog = dogs?[indexPath.row] {
            if cell.isSelected == false {
                if let index = selectedDogs.firstIndex(of: deselectedDog) {
                    selectedDogs.remove(at: index)
                }
            }
            delegate?.passSelectedDogsData(selectedDogs)
        }
    }
    
    
}

//MARK: - PassDataDelegate
protocol PassSelectedDogsDelegate {
    func passSelectedDogsData(_ data: [Dog]?)
}
