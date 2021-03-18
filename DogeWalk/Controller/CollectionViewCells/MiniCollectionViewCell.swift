//
//  MiniCollectionViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.03.21.
//

import UIKit

class MiniCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dogImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogImage.layer.cornerRadius = self.frame.height / 2
    }
}
