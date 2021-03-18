//
//  DogOverviewTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.03.21.
//

import UIKit

class DogOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var toyLabel: UILabel!
    @IBOutlet weak var treatLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogImage.layer.cornerRadius = self.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
