//
//  SelectDogsPreWalkViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit

class PreWalkViewController: UIViewController {
    
    @IBOutlet weak var preWalkCollectionViewController: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContinueButton()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        // segue to CurrentwalkViewController
    }
    
    fileprivate func setContinueButton() {
        // set the button to have a gradient and rounded corners
        continueButton.layer.cornerRadius = 15
        continueButton.clipsToBounds = true
        continueButton.setGradientBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
}
