//
//  BreedSelectorTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 10.06.21.
//

import UIKit

class BreedSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var breedSelectorCellBackground: UIView!
    @IBOutlet weak var breedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        breedSelectorCellBackground.layer.cornerRadius = 5
        breedSelectorCellBackground.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
