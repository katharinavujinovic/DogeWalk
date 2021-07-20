//
//  WalkSortingTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 20.07.21.
//

import UIKit

class WalkSortingTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowIndicator: UIImageView!
    @IBOutlet weak var sortingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
