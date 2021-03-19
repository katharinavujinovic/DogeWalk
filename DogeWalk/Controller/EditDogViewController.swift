//
//  EditDogViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 15.03.21.
//

import Foundation
import UIKit
import CoreData

// When "has launched before" is false, this needs to be the first page to start with. In that case, hide the toolbar, so the user can't cancel oder edit

class EditDogViewController: UIViewController {
    // deletes the dog from a library after showing an alarm
    @IBOutlet weak var deleteDog: UIButton!
    
    @IBOutlet weak var selectDogButton: UIButton!
    @IBOutlet weak var dogImage: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var toyTextField: UITextField!
    @IBOutlet weak var treatTextField: UITextField!
    
    @IBOutlet weak var breedPicker: UIPickerView!
    // femaleButton and maleButton
    @IBOutlet weak var genderTint: UIView!
    @IBOutlet weak var femaleIcon: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var addNewDogButton: UIButton!
    
    var allBreeds: [String] = []
    var sortedBreeds: [String] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dogImage.layer.cornerRadius = dogImage.frame.height / 2
        addNewDogButton.layer.cornerRadius = 15
        DogBreedAPI.fetchBreedList(url: DogBreedAPI.dogURL) { (data, error) in
            if let data = data {
                self.allBreeds = Array(data.message.keys)
                self.sortedBreeds = self.allBreeds.sorted()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedPicker.delegate = self
        breedPicker.dataSource = self
    }
    
    
    @IBAction func selectImageButton(_ sender: Any) {
    // select Dogimage from camera roll or take a picture
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderIconReaction(mainColor: #colorLiteral(red: 0.9803921569, green: 0.537254902, blue: 0.4823529412, alpha: 1), hightlightColor: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.5803921569, alpha: 1), female: true, male: false)
    
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderIconReaction(mainColor: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), hightlightColor: #colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.6470588235, alpha: 1), female: false, male: true)
    }
    
    
    @IBAction func addNewDogPressed(_ sender: Any) {
    // segue to DogOverViewController
    }
    
    
    // setting the Response when one or the other icon is tapped
    fileprivate func genderIconReaction(mainColor: UIColor, hightlightColor: UIColor, female: Bool, male: Bool) {
        genderTint.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        maleIcon.isHighlighted = male
        femaleIcon.isHighlighted = female
        genderTint.setGradientViewBackground(colorOne: mainColor, colorTwo: hightlightColor, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
}

//MARK: - UIPicker
extension EditDogViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allBreeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortedBreeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // let selectedDogBreed = dogBreed[row]
        // save the breed to you CoreData
    }
}
