//
//  WalkSortingTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 20.07.21.
//

import UIKit

class SortingTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowIndicator: UIImageView!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    var isAscending = true
    var delegate: PassAscendingValueDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            isAscending = !isAscending
            self.accessoryType = .checkmark
            sortingLabel.font = UIFont.boldSystemFont(ofSize: 17)
            if isAscending {
                self.arrowIndicator.image = UIImage(named: "ArrowUp")
            } else {
                self.arrowIndicator.image = UIImage(named: "ArrowDown")
            }
            print("When selected, ascending is: \(isAscending)")
            delegate?.passAscendingValue(isAscending)
        } else {
            self.accessoryType = .none
            self.arrowIndicator.image = nil
            isAscending = true
        }
        
    }
}

//MARK: - PassDataDelegate
protocol PassAscendingValueDelegate {
    func passAscendingValue(_ data: Bool?)
}
