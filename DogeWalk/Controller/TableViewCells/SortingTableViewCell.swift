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
        if self.isSelected {
            isAscending = UserDefaults.standard.bool(forKey: "ascending")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.cellBackground.alpha = 1
            isAscending = !isAscending
            self.accessoryType = .checkmark
            if isAscending {
                self.arrowIndicator.image = UIImage(systemName: "arrow.up")
            } else {
                self.arrowIndicator.image = UIImage(systemName: "arrow.down")
            }
            print("When selected, ascending is: \(isAscending)")
            delegate?.passAscendingValue(isAscending)
        } else {
            self.cellBackground.alpha = 0.5
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
