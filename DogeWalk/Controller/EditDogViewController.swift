//
//  EditDogViewController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 15.03.21.
//

import Foundation
import UIKit
import RealmSwift

class EditDogViewController: UIViewController {
    // deletes the dog from a library after showing an alarm
    @IBOutlet weak var deleteDog: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectDogButton: UIButton!
    @IBOutlet weak var dogImage: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var chipIDTextField: UITextField!
    @IBOutlet weak var neuteredSwitch: UISwitch!
    @IBOutlet weak var toyTextField: UITextField!
    @IBOutlet weak var treatTextField: UITextField!
    
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    // femaleButton and maleButton
    @IBOutlet weak var femaleIcon: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var maleButton: UIButton!

    @IBOutlet weak var addNewDogButton: UIButton!
    
    let realm = try! Realm()
    var converter = Converter()
    var dogBreeds = DogBreeds()
    
    var selectedDogBreed: String?
    var dog: Dog?
    fileprivate var dogBirthday: Date?

    fileprivate var datePicker = UIDatePicker()
    fileprivate var genderIsFemale: Bool?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dogImage.layer.cornerRadius = dogImage.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.dismissKeyboard()
        nameTextField.delegate = self
        toyTextField.delegate = self
        treatTextField.delegate = self
        weightTextField.delegate = self
        heightTextField.delegate = self
        chipIDTextField.delegate = self
        
        setAddDogButton()
        NotificationCenter.default.addObserver(self, selector: #selector(EditDogViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        setInterface()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        birthdayPicker.maximumDate = Date()
    }

    
    fileprivate func setInterface() {
        // to have slightly difference UI fow newDogPressed and editing an existing dog
        if dog != nil {
            DispatchQueue.main.async { [self] in
                addNewDogButton.isHidden = true
                dogImage.image = UIImage(data: dog!.profile)
                nameTextField.text = dog?.name
                breedLabel.text = dog?.breed
                
                if let dogBirthdayDate = dog?.age {
                    datePicker.date = dogBirthdayDate
                }
                if dog?.weight != 0.0 {
                    weightTextField.text = "\(dog!.weight)"
                }
                if dog?.height != 0.0 {
                    heightTextField.text = "\(dog!.height)"
                }
                if let dogChipID = dog?.chipID {
                    chipIDTextField.text = dogChipID
                }
                if dog?.neutered == true {
                    neuteredSwitch.isOn = true
                }
                
                toyTextField.text = dog?.favouriteToy
                treatTextField.text = dog?.favouriteTreat

                genderIsFemale = dog?.isFemale
                
                if dog?.isFemale == true {
                    genderIconReaction(female: true, male: false)
                } else {
                    genderIconReaction(female: false, male: true)
                }
            }
        } else {
            saveButton.isHidden = true
            deleteDog.isHidden = true
        }
    }
    
//MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.breedTableView {
            if let view = segue.destination as? DogBreedPopUp {
//                view.popoverPresentationController?.delegate = self
                view.delegate = self
                if breedLabel.text != "" {
                    let arrayOfBreeds = breedLabel.text!.components(separatedBy: ", ")
                    view.selectedDogBreeds = arrayOfBreeds
                }
            }
        }
    }
    
//MARK: - Keyboard Management
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        DispatchQueue.main.async {
            let contentsInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentsInsets
            self.scrollView.scrollIndicatorInsets = contentsInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async {
            let contentsInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.scrollView.contentInset = contentsInsets
            self.scrollView.scrollIndicatorInsets = contentsInsets
        }
    }

    
//MARK: - Gender Color Shift
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderIconReaction(female: true, male: false)
        genderIsFemale = true
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderIconReaction(female: false, male: true)
        genderIsFemale = false
    }
    
    // setting the Response when one or the other icon is tapped
    fileprivate func genderIconReaction(female: Bool, male: Bool) {
        maleIcon.isHighlighted = male
        femaleIcon.isHighlighted = female
    }
 
    fileprivate func setAddDogButton() {
        addNewDogButton.layer.cornerRadius = 15
        addNewDogButton.clipsToBounds = true
        addNewDogButton.setGradientBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
//MARK: - Archiving

    @IBAction func addNewDogPressed(_ sender: Any) {
        if nameTextField.text == "" {
            nameTextField.placeholder = Constants.AlertMessages.missingName
        } else {
            DispatchQueue.main.async { [self] in
                // dogBirthday is nil!
                if converter.dayFormatter(date: birthdayPicker.date) != converter.dayFormatter(date: Date()) {
                    dogBirthday = birthdayPicker.date
                }
                self.archiveNewDog(name: nameTextField.text!, image: dogImage.image!, age: dogBirthday, breed: breedLabel.text, isFemale: genderIsFemale ?? true, favouritToy: toyTextField.text, favouriteTreat: treatTextField.text, chipID: chipIDTextField.text)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
    @IBAction func deleteDogPressed(_ sender: Any) {
        let alert = UIAlertController(title: Constants.AlertMessages.removeDogTitle, message: Constants.AlertMessages.removeDogMessage, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: Constants.AlertMessages.removeDog, style: .default) { [self] (action: UIAlertAction) in
            if self.dog != nil {
                do {
                    try realm.write {
                        realm.delete(dog!)
                    }
                } catch {
                    print("Error deleting item, \(error)")
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: Constants.AlertMessages.keepDog, style: .default) { (action: UIAlertAction) in
            return
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
 //       setSaving(isSaving: true)
        if dog != nil {
            do {
                try realm.write {
                    dog?.name = nameTextField.text!
                    dog?.profile = (dogImage.image?.pngData())!
                    dog?.isFemale = genderIsFemale ?? true
                    dog?.breed = breedLabel.text
                    if converter.dayFormatter(date: birthdayPicker.date) != converter.dayFormatter(date: Date()) {
                        dog?.age = birthdayPicker.date
                    }

                    dog?.favouriteToy = toyTextField.text
                    dog?.favouriteTreat = treatTextField.text
                    dog?.chipID = chipIDTextField.text
                    dog?.neutered = neuteredSwitch.isOn
                    if weightTextField.text != "" {
                        guard let weightInDouble = Double(weightTextField.text!) else {
                            fatalError("Cannot convert weight into a number")
                        }
                        dog?.weight = weightInDouble
                    }
                    if heightTextField.text != "" {
                        guard let heightInDouble = Double(heightTextField.text!) else {
                            fatalError("Cannot convert weight into a number")
                        }
                        dog?.height = heightInDouble
                    }
                }
            } catch {
                print("Error saving modified dog, \(error)")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func archiveNewDog(name: String, image: UIImage, age: Date?, breed: String?, isFemale: Bool, favouritToy: String?, favouriteTreat: String?, chipID: String?) {
        do {
            try realm.write {
                let newDog = Dog()
                newDog.name = name
                newDog.profile = image.pngData()!
                if age != nil {
                    if converter.dayFormatter(date: age!) != converter.dayFormatter(date: Date()) {
                        newDog.age = age
                    }
                }
                newDog.breed = breed
                newDog.isFemale = isFemale
                newDog.favouriteToy = favouritToy
                newDog.favouriteTreat = favouriteTreat
                newDog.chipID = chipID
                newDog.neutered = neuteredSwitch.isOn
                if weightTextField.text != "" {
                    guard let weightInDouble = Double(weightTextField.text!) else {
                        fatalError("Cannot convert weight into a number")
                    }
                    newDog.weight = weightInDouble
                }
                if heightTextField.text != "" {
                    guard let heightInDouble = Double(heightTextField.text!) else {
                        fatalError("Cannot convert weight into a number")
                    }
                    newDog.height = heightInDouble
                }
                realm.add(newDog)
            }
        } catch {
            print("Error saving new Dog, \(error)")
        }
    }

}

//MARK: - ImagePicker
extension EditDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func selectImageButton(_ sender: Any) {
        let alert = UIAlertController(title: Constants.AlertMessages.addImageTitle, message: Constants.AlertMessages.addImageMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.fromLibrary, style: .default, handler: { (action) in
            self.pickAnImage(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.fromCamera, style: .default, handler: { (action) in
            self.pickAnImage(sourceType: .camera)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizedImage = resizeImage(image: chosenImage, targetSize: CGSize(width: 300, height: 300))
            self.dogImage.image = resizedImage
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

extension EditDogViewController: PassDataDelegate {
    func passData(_ data: [String]?) {
        breedLabel.text = data?.joined(separator: ", ")
    }
    
}


