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
    
    var isAscending = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.sortingLabel.font = UIFont.boldSystemFont(ofSize: 17)
                if isAscending {
                    arrowIndicator.image = UIImage(systemName: "arrow.up")
                } else {
                    arrowIndicator.image = UIImage(systemName: "arrow.down")
                }
            } else {
                arrowIndicator.image = nil
            }
        }
    }
    
}
