//
//  DogMiniCollectionViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 29.06.21.
//

import UIKit

class DogMiniCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dogImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogImage.layer.cornerRadius = dogImage.frame.width / 2
        // Initialization code
    }

}
