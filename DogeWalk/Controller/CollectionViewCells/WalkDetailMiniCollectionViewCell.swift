//
//  WalkDetailMiniCollectionViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 14.04.21.
//

import UIKit

class WalkDetailMiniCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var miniImage: UIImageView!
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = self.frame.height / 2
    }
}
