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
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        miniCollectionView.delegate = dataSourceDelegate
        miniCollectionView.dataSource = dataSourceDelegate
        miniCollectionView.tag = row
        miniCollectionView.reloadData()
    }
    
}

