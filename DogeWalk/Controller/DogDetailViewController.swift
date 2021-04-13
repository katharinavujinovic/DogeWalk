//
//  DogDetailViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import Foundation
import UIKit
import MapKit

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

    var dog: Dog!
    var walks: [Walk] = []
    var selectedWalk: Walk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nib registration
        let nib = UINib(nibName: "WalksOverviewTableViewCell", bundle: nil)
        dogDetailTableView.register(nib, forCellReuseIdentifier: "WalksOverviewTableViewCell")
        // delegation assigning
        dogDetailTableView.delegate = self
        dogDetailTableView.dataSource = self
        // UI
        dogImage.layer.cornerRadius = dogImage.frame.height / 2
        setDogProfile()
    }
    
    // Perform a segue to the EditDogVC to adjust and alter the dogs properties
    @IBAction func dogStatsPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.dogDetailToEdit, sender: self)
    }
    
    //MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.dogDetailToEdit {
            let editVC = segue.destination as! EditDogViewController
            editVC.dog = dog
        }
        if segue.identifier == Constants.Segue.dogDetailToWalkDetail {
            let walkDetailVC = segue.destination as! WalkDetailViewController
            walkDetailVC.walk = selectedWalk
        }
    }

    // Set UI
    func setDogProfile() {
        dogImage.image = UIImage(data: dog.profile!)
        nameLabel.text = dog.name
        ageLabel.text = "\(dog.age)"
        breedLabel.text = dog.breed
        toyChoice.text = dog.favouriteToy
        treatChoice.text = dog.favouriteTreat
        // set the backgroundcolor based on gender of dog
        if dog.gender == "female" {
            setcoloredViewBackground(maincolor: #colorLiteral(red: 0.9803921569, green: 0.537254902, blue: 0.4823529412, alpha: 1), highlightcolor: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.5803921569, alpha: 1))
        } else {
            setcoloredViewBackground(maincolor: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), highlightcolor: #colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.6470588235, alpha: 1))
        }
        let setOfWalks = dog.participatedWalks!
        walks = setOfWalks.allObjects as! [Walk]
    }
    
    // Set Background of coloredView
    func setcoloredViewBackground(maincolor: UIColor, highlightcolor: UIColor) {
        coloredView.layer.cornerRadius = 10
        coloredView.clipsToBounds = true
        coloredView.setGradientViewBackground(colorOne: maincolor, colorTwo: highlightcolor, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
}

//MARK: - UITableView
extension DogDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aWalk = walks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalksOverviewTableViewCell") as! WalksOverviewTableViewCell
        cell.dateLabel.text = timeFormatter(date: aWalk.date!)
        cell.distancelabel.text = aWalk.distance
        cell.startTimeLabel.text = aWalk.startTime
        cell.timeLabel.text = aWalk.time
        let locations = aWalk.route!
        cell.mapView.addOverlay(createPolyLine(locations: locations))
        let viewRegion = MKCoordinateRegion(center: aWalk.route![0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        cell.mapView.setRegion(viewRegion, animated: true)
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWalk = walks[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.dogDetailToWalkDetail, sender: self)
    }
}
