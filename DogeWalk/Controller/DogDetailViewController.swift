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
    @IBOutlet weak var dogTableView: UITableView!
    @IBOutlet weak var walksTableView: UITableView!
    // Dog stats

    var dog: Dog!
    var walks: [Walk] = []
    var selectedWalk: Walk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nib registration
        let dogNib = UINib(nibName: "DogOverviewTableViewCell", bundle: nil)
        dogTableView.register(dogNib, forCellReuseIdentifier: "DogOverviewTableViewCell")
        
        let walkNib = UINib(nibName: "WalksOverviewTableViewCell", bundle: nil)
        walksTableView.register(walkNib, forCellReuseIdentifier: "WalksOverviewTableViewCell")
        // delegation assigning
        walksTableView.delegate = self
        walksTableView.dataSource = self
        dogTableView.delegate = self
        dogTableView.dataSource = self
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
    
    func setbackgroundTint(_ cell: DogOverviewTableViewCell, colorOne: UIColor, colorTwo: UIColor) {
        cell.backgroundTint.setGradientViewBackground(colorOne: colorOne, colorTwo: colorTwo, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
}

//MARK: - UITableView
extension DogDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.walksTableView {
            if walks.count == 0 {
                return 1
            } else {
                return walks.count
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create an idicator when there are no walks yet
        if tableView == self.walksTableView {
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
        else if tableView == self.dogTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DogOverviewTableViewCell") as! DogOverviewTableViewCell
            cell.dogImage.image = UIImage(data: dog.profile!)
            cell.ageLabel.text = "\(dog.age)"
            cell.breedLabel.text = dog.breed
            cell.nameLabel.text = dog.name
            cell.toyLabel.text = dog.favouriteToy
            cell.treatLabel.text = dog.favouriteTreat
            
            if dog.isFemale == true {
                setbackgroundTint(cell, colorOne: #colorLiteral(red: 0.9803921569, green: 0.537254902, blue: 0.4823529412, alpha: 1), colorTwo: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.5803921569, alpha: 1))
            } else {
                setbackgroundTint(cell, colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.6470588235, alpha: 1))
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
        
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.walksTableView {
        selectedWalk = walks[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.dogDetailToWalkDetail, sender: self)
        }
        if tableView == self.dogTableView {
            performSegue(withIdentifier: Constants.Segue.dogDetailToEdit, sender: self)
        }
    }
}
