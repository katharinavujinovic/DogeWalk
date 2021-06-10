//
//  DogBreedTableView.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.05.21.
//

import Foundation
import UIKit

class DogBreedPopUp: UIViewController {
    
    @IBOutlet weak var dogBreedTableView: UITableView!
    @IBOutlet weak var selectedBreedTableView: UITableView!
    @IBOutlet weak var breedSearchBar: UISearchBar!
    @IBOutlet weak var selectedDogBreedsLabel: UILabel!
    
    let dogBreeds = DogBreeds()
    var data: [String] = []
    var searchedData: [String] = []
    var delegate: PassDataDelegate?
    var selectedDogBreeds: [String]?
    var searchActive = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        data = dogBreeds.arrayOfAllBreeds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "BreedSelectorTableViewCell", bundle: nil)
        dogBreedTableView.register(nib, forCellReuseIdentifier: "BreedSelectorTableViewCell")
        
        dogBreedTableView.dataSource = self
        dogBreedTableView.delegate = self
        breedSearchBar.delegate = self
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        delegate?.passData(selectedDogBreeds)
        self.dismiss(animated: true, completion: nil)

    }
}

//MARK: - TableView
extension DogBreedPopUp: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.selectedBreedTableView {
            return selectedDogBreeds?.count ?? 0
        }
        else if tableView == self.dogBreedTableView {
            if searchActive {
                return searchedData.count
            } else {
                return data.count
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.selectedBreedTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BreedSelectorTableViewCell") as! BreedSelectorTableViewCell
            if selectedDogBreeds != nil {
                cell.breedLabel.text = selectedDogBreeds![indexPath.row]
            }
            return cell
        }
        else if tableView == self.dogBreedTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if searchActive {
                cell.textLabel?.text = searchedData[indexPath.row]
            } else {
                cell.textLabel?.text = data[indexPath.row]
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.selectedBreedTableView {
            if searchActive {
                if let index = selectedDogBreeds?.firstIndex(of: searchedData[indexPath.row]) {
                    selectedDogBreeds?.remove(at: index)
                }
            } else {
                if let index = selectedDogBreeds?.firstIndex(of: data[indexPath.row]) {
                    selectedDogBreeds?.remove(at: index)
                }
            }
        }
        else if tableView == self.dogBreedTableView {
            if searchActive {
                if ((selectedDogBreeds?.contains(searchedData[indexPath.row])) != nil) {
                    return
                } else {
                    selectedDogBreeds?.append(searchedData[indexPath.row])
                }
            } else {
                if ((selectedDogBreeds?.contains(data[indexPath.row])) != nil) {
                    return
                } else {
                    selectedDogBreeds?.append(data[indexPath.row])
                }
            }
        }
    }
}

//MARK: - Searchbar
extension DogBreedPopUp: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedData = data.filter({$0.lowercased().contains(searchText.lowercased())})
        searchActive = true
        dogBreedTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        breedSearchBar.text = ""
        dogBreedTableView.reloadData()
    }
    
}

//MARK: - PassDataDelegate
protocol PassDataDelegate {
    func passData(_ data: [String]?)
}
