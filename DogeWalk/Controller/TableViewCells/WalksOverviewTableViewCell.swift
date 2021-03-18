//
//  WalksOverviewTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 18.03.21.
//

import UIKit

class WalksOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var miniCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var distancelabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// https://stackoverflow.com/questions/52104047/how-to-properly-add-an-uicollectionview-inside-uitableviewcell-using-ios-12
