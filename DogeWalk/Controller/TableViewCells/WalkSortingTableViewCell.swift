//
//  WalkSortingTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 21.07.21.
//

import UIKit

class WalkSortingTableViewCell: UITableViewCell {

    @IBOutlet weak var walkSortingTableView: UITableView!
    
    //sorting option
    var sortingOptions = ["Distance", "Date", "Duration"]
    var selectedItem: String?
    var isAscending: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: Constants.Nibs.sortingTableViewCell, bundle: nil)
        walkSortingTableView.register(nib, forCellReuseIdentifier: Constants.Nibs.sortingTableViewCell)
        walkSortingTableView.delegate = self
        walkSortingTableView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension WalkSortingTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.sortingTableViewCell, for: indexPath) as! SortingTableViewCell
        cell.sortingLabel.text = sortingOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nibs.sortingTableViewCell, for: indexPath) as! SortingTableViewCell
        cell.sortingLabel.text = sortingOptions[indexPath.row]
        
        let sortingSelection = sortingOptions[indexPath.row]
                
        switch sortingSelection {
        case "Distance":
            if selectedItem != "distance" {
                selectedItem = "distance"
                isAscending = false
                cell.arrowIndicator.image = UIImage(named: "arrow.down")
            } else {
                isAscending = true
                cell.arrowIndicator.image = UIImage(named: "arrow.up")
            }
            UserDefaults.standard.set("distance", forKey: "sortBy")
            print("distance pressed")
        case "Date":
            UserDefaults.standard.set("startDate", forKey: "sortBy")
            print("date pressed")
        case "Duration":
            UserDefaults.standard.set("time", forKey: "sortBy")
            print("duration pressed")
        default:
            break
        }
    }
    
}
