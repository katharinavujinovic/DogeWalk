//
//  DogSelectionCollectionViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.03.21.
//

import UIKit

class DogSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var dogImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.layer.cornerRadius = self.frame.height / 2
        selectionView.setGradientViewBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
        selectionView.isHidden = true
        dogImage.layer.cornerRadius = self.frame.height / 2
    }
    
    
}
