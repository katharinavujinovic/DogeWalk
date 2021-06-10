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
        breedSelectorCellBackground.setGradientViewBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
