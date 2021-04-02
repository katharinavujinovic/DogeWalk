//
//  EditDogViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 15.03.21.
//

import Foundation
import UIKit
import CoreData

class EditDogViewController: UIViewController, NSFetchedResultsControllerDelegate {
    // deletes the dog from a library after showing an alarm
    @IBOutlet weak var deleteDog: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
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
    var selectedDogBreed = ""
    
    var fetchedResultsController: NSFetchedResultsController<Dog>!
    var dog: Dog?
    
    var genderOfDog = ""
    
    
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
        // to have slightly difference UI fow newDogPressed and editing an existing dog
        if dog != nil {
            addNewDogButton.isHidden = true
        } else {
            saveButton.isHidden = true
        }
    }
    
    

    
    
//MARK: - Gender Color Shift
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderIconReaction(mainColor: #colorLiteral(red: 0.9803921569, green: 0.537254902, blue: 0.4823529412, alpha: 1), hightlightColor: #colorLiteral(red: 1, green: 0.8666666667, blue: 0.5803921569, alpha: 1), female: true, male: false)
        genderOfDog = "female"
    
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderIconReaction(mainColor: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), hightlightColor: #colorLiteral(red: 0.8156862745, green: 0.9019607843, blue: 0.6470588235, alpha: 1), female: false, male: true)
        genderOfDog = "male"
    }
    

    // setting the Response when one or the other icon is tapped
    fileprivate func genderIconReaction(mainColor: UIColor, hightlightColor: UIColor, female: Bool, male: Bool) {
        genderTint.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        maleIcon.isHighlighted = male
        femaleIcon.isHighlighted = female
        genderTint.setGradientViewBackground(colorOne: mainColor, colorTwo: hightlightColor, gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
 
    
//MARK: - Saving
    
    @IBAction func addNewDogPressed(_ sender: Any) {
        if nameTextField.text == "" || genderOfDog == "" {
            // print an alarm that we need at least name and gender of dog
        } else {
            archiveNewDog(name: nameTextField.text!, image: dogImage.image!, age: Int16(ageTextField.text!)!, breed: selectedDogBreed, gender: genderOfDog, favouritToy: toyTextField.text ?? "", favouriteTreat: treatTextField.text ?? "")
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dog?.name = nameTextField.text
        dog?.profile = dogImage.image?.pngData()
        dog?.breed = selectedDogBreed
        dog?.age = Int16(ageTextField.text!)!
        dog?.favouriteToy = toyTextField.text
        dog?.favouriteTreat = treatTextField.text
        DataController.dataController.saveViewContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    func archiveNewDog(name: String, image: UIImage, age: Int16, breed: String, gender: String, favouritToy: String, favouriteTreat: String) {
        let newDog = Dog(context: DataController.dataController.viewContext)
        newDog.name = name
        newDog.profile = image.pngData()
        newDog.age = age
        newDog.breed = breed
        newDog.gender = gender
        newDog.favouriteToy = favouritToy
        newDog.favouriteTreat = favouriteTreat
        DataController.dataController.saveViewContext()
        self.dismiss(animated: true, completion: nil)
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
        selectedDogBreed = sortedBreeds[row]
    }
}

//MARK: - ImagePicker
extension EditDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func selectImageButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Image", message: "Select how you want to add an Image", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { (action) in
            self.pickAnImage(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Take Picture with Camera", style: .default, handler: { (action) in
            self.pickAnImage(sourceType: .camera)
        }))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dogImage.image = chosenImage
        } else {
            print("not able to use image")
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
}
