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
        dogImage.layer.cornerRadius = dogImage.frame.height / 2
    }
    
    class var reuseIdentifier: String {
        return "MiniCollectionViewCell"
    }
    
    class var nibName: String {
        return "MiniCollectionViewCell"
    }
}
