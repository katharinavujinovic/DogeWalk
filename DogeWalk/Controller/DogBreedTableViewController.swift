//
//  DogBreedTableView.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.05.21.
//

import Foundation
import UIKit

class DogBreedTableViewController: UIViewController {
    
    @IBOutlet weak var dogBreedTableView: UITableView!
    @IBOutlet weak var breedSearchBar: UISearchBar!
    @IBOutlet weak var selectedDogBreedsLabel: UILabel!
    
    let dogBreeds = DogBreeds()
    var data: [String] = []
    var searchedData: [String] = []
    var delegate: PassDataDelegate?
    var selectedDogBreeds: String?
    var searchActive = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        data = dogBreeds.arrayOfAllBreeds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogBreedTableView.dataSource = self
        dogBreedTableView.delegate = self
        breedSearchBar.delegate = self
        if selectedDogBreeds != nil {
            selectedDogBreedsLabel.text = selectedDogBreeds
        } else {
            selectedDogBreedsLabel.text = ""
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func xPressed(_ sender: Any) {
        selectedDogBreeds = nil
        selectedDogBreedsLabel.text = ""
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        delegate?.passData(selectedDogBreeds ?? "" )
        self.dismiss(animated: true, completion: nil)

    }
}

//MARK: - TableView
extension DogBreedTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return searchedData.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if searchActive {
            cell.textLabel?.text = searchedData[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsMultipleSelection = true
        if searchActive {
            if selectedDogBreeds == nil {
                selectedDogBreeds = "\(searchedData[indexPath.row])"
            } else {
                selectedDogBreeds! += ", \(searchedData[indexPath.row])"
            }
            
        } else {
            if selectedDogBreeds == nil {
                selectedDogBreeds = "\(data[indexPath.row])"
            } else {
                selectedDogBreeds! += ", \(data[indexPath.row]), "
            }
            
        }
        selectedDogBreedsLabel.text = "\(selectedDogBreeds!)"
    }
}

//MARK: - Searchbar
extension DogBreedTableViewController: UISearchBarDelegate {
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
    func passData(_ data: String)
}
