//
//  DogDetailViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit

class DogDetailViewController: UIViewController {
    // displays the walks the dog finished
    @IBOutlet weak var dogDetailTableView: UITableView!
    // Dog stats
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var toyChoice: UILabel!
    @IBOutlet weak var treatChoice: UILabel!
    // is either pink or blue depending on gender of dog
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var editButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImage.layer.cornerRadius = dogImage.frame.height / 2
        // set the backgroundcolor based on gender of dog
//        setcoloredViewBackground(maincolor: <#UIColor#>, highlightcolor: <#UIColor#>)
    }
    
    @IBAction func dogStatsPressed(_ sender: Any) {
    // perform segue to EditDogView
    }

    
    fileprivate func setcoloredViewBackground(maincolor: UIColor, highlightcolor: UIColor) {
        coloredView.layer.cornerRadius = 10
        coloredView.clipsToBounds = true
        coloredView.setGradientViewBackground(colorOne: maincolor, colorTwo: highlightcolor, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
}
