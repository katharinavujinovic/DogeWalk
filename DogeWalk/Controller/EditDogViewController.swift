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
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectDogButton: UIButton!
    @IBOutlet weak var dogImage: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var toyTextField: UITextField!
    @IBOutlet weak var treatTextField: UITextField!
    
    @IBOutlet weak var breedPicker: UIPickerView!
    // femaleButton and maleButton
    @IBOutlet weak var femaleIcon: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var savingScreen: UIView!
    @IBOutlet weak var savingIndicator: UIActivityIndicatorView!
    
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
        setAddDogButton()
        NotificationCenter.default.addObserver(self, selector: #selector(EditDogViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // to have slightly difference UI fow newDogPressed and editing an existing dog
        if dog != nil {
            addNewDogButton.isHidden = true
            dogImage.image = UIImage(data: dog!.profile!)
            nameTextField.text = dog?.name
            ageTextField.text = "\(dog!.age)"
            toyTextField.text = dog?.favouriteToy
            treatTextField.text = dog?.favouriteTreat
            if dog?.gender == "female" {
                genderIconReaction(female: true, male: false)
            } else {
                genderIconReaction(female: false, male: true)
            }
            
        } else {
            saveButton.isHidden = true
            deleteDog.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK: - Keyboard Management
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        let contentsInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentsInsets
        scrollView.scrollIndicatorInsets = contentsInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentsInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentsInsets
        scrollView.scrollIndicatorInsets = contentsInsets
    }
    
    
//MARK: - Gender Color Shift
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderIconReaction(female: true, male: false)
        genderOfDog = "female"
    
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderIconReaction(female: false, male: true)
        genderOfDog = "male"
    }
    

    // setting the Response when one or the other icon is tapped
    fileprivate func genderIconReaction(female: Bool, male: Bool) {
        maleIcon.isHighlighted = male
        femaleIcon.isHighlighted = female
    }
 
    func setAddDogButton() {
        addNewDogButton.layer.cornerRadius = 15
        addNewDogButton.clipsToBounds = true
        addNewDogButton.setGradientBackground(colorOne: #colorLiteral(red: 0.5254901961, green: 0.8901960784, blue: 0.8078431373, alpha: 1), colorTwo: #colorLiteral(red: 0.9803921569, green: 0.7568627451, blue: 0.4470588235, alpha: 1), gradientbrake: [0.0, 1.0], startX: 0.0, startY: 1.0, endX: 1.0, endY: 0.0)
    }
    
//MARK: - Saving
    
    @IBAction func addNewDogPressed(_ sender: Any) {
        if nameTextField.text == "" || genderOfDog == "" {
            nameTextField.placeholder = "Please give your Dog a name"
        } else {
            setSaving(isSaving: true)
            archiveNewDog(name: nameTextField.text!, image: dogImage.image!, age: Int16(ageTextField.text!)!, breed: selectedDogBreed, gender: genderOfDog, favouritToy: toyTextField.text ?? "", favouriteTreat: treatTextField.text ?? "")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        setSaving(isSaving: true)
        dog?.name = nameTextField.text
        dog?.profile = dogImage.image?.pngData()
        dog?.breed = selectedDogBreed
        dog?.age = Int16(ageTextField.text!)!
        dog?.favouriteToy = toyTextField.text
        dog?.favouriteTreat = treatTextField.text
        DataController.shared.saveViewContext()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func archiveNewDog(name: String, image: UIImage, age: Int16, breed: String, gender: String, favouritToy: String, favouriteTreat: String) {
        let newDog = Dog(context: DataController.shared.viewContext)
        newDog.name = name
        newDog.profile = image.pngData()
        newDog.age = age
        newDog.breed = breed
        newDog.gender = gender
        newDog.favouriteToy = favouritToy
        newDog.favouriteTreat = favouriteTreat
        DataController.shared.saveViewContext()
    }
    
    func setSaving(isSaving: Bool) {
        if isSaving {
            savingScreen.isHidden = false
            savingIndicator.startAnimating()
        } else {
            savingScreen.isHidden = true
            savingIndicator.stopAnimating()
        }
        selectDogButton.isEnabled = !isSaving
        ageTextField.isEnabled = !isSaving
        femaleButton.isEnabled = !isSaving
        maleButton.isEnabled = !isSaving
        breedPicker.isUserInteractionEnabled = !isSaving
        toyTextField.isEnabled = !isSaving
        treatTextField.isEnabled = !isSaving
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
        self.present(alert, animated: true, completion: nil)
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


