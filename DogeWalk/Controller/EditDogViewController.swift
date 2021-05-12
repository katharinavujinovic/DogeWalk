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
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var toyTextField: UITextField!
    @IBOutlet weak var treatTextField: UITextField!
    
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var breedPickerActivityIndicator: UIActivityIndicatorView!
    
    // femaleButton and maleButton
    @IBOutlet weak var femaleIcon: UIImageView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var savingScreen: UIView!
    @IBOutlet weak var savingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addNewDogButton: UIButton!
    
    let realm = try! Realm()
    var allBreeds: [String] = []
    var sortedBreeds: [String] = []
    var selectedDogBreed = ""
    var dog: Dog?
    private var dogBirthday: Date?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    private var datePicker: UIDatePicker?
    
    var genderOfDog: Bool?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dogImage.layer.cornerRadius = dogImage.frame.height / 2
        loadBreedList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.dismissKeyboard()
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
        nameTextField.delegate = self
        toyTextField.delegate = self
        treatTextField.delegate = self
        
        ageTextField.inputView = datePicker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(EditDogViewController.birthDayEntered(datePicker:)), for: .valueChanged)
//        checkNetwork()
        setAddDogButton()
        NotificationCenter.default.addObserver(self, selector: #selector(EditDogViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        setInterface()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func birthDayEntered(datePicker: UIDatePicker) {
        
        dogBirthday = datePicker.date
        

        ageTextField.text = dateFormatter.string(from: dogBirthday!)
        view.endEditing(true)
    }
    
    
    func loadBreedList() {
        DogBreedAPI.fetchBreedList(url: DogBreedAPI.dogURL) { (dogResponse, error) in
                if let dogResponse = dogResponse {
                    self.allBreeds = Array(dogResponse.message.keys)
                    self.sortedBreeds = self.allBreeds.sorted()
                    DispatchQueue.main.async {
                        self.breedPickerActivityIndicator.stopAnimating()
                        self.breedPicker.reloadAllComponents()
                    }
                } else {
                    print("your error is: \(error!.localizedDescription)")
                }
        }
        displayNetworkIssue()
    }
    
    func displayNetworkIssue() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
            if self.allBreeds == [] {
                DispatchQueue.main.async {
                    self.breedPickerActivityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Very Slow or No Internet Connection", message: "Don't Worry, you can come back to this profile another time to add the breed", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    func setInterface() {
        // to have slightly difference UI fow newDogPressed and editing an existing dog
        if dog != nil {
            DispatchQueue.main.async { [self] in
                addNewDogButton.isHidden = true
                dogImage.image = UIImage(data: dog!.profile)
                nameTextField.text = dog?.name
                
                if dog?.age != nil {
                    ageTextField.text = dateFormatter.string(from: dog!.age!)
                }
                
                toyTextField.text = dog?.favouriteToy
                treatTextField.text = dog?.favouriteTreat

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
        genderOfDog = true
    
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderIconReaction(female: false, male: true)
        genderOfDog = false
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
    /*
    @IBAction func addNewDogPressed(_ sender: Any) {
        if nameTextField.text == "" || genderOfDog == nil {
            nameTextField.placeholder = "Please give your Dog a name"
        } else {
            setSaving(isSaving: true)
            DispatchQueue.main.async {
                self.archiveNewDog(name: self.nameTextField.text!, image: self.dogImage.image!, age: Int16(self.ageTextField.text!)!, breed: self.selectedDogBreed, isFemale: self.genderOfDog!, favouritToy: self.toyTextField.text ?? "", favouriteTreat: self.treatTextField.text ?? "")
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
 */
    
    @IBAction func deleteDogPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to remove this dog?", message: "By confirming, this dog will be deleted", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete Dog", style: .default) { [self] (action: UIAlertAction) in
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
        let cancelAction = UIAlertAction(title: "Keep Dog", style: .default) { (action: UIAlertAction) in
            return
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        setSaving(isSaving: true)
        if dog != nil {
            do {
                try realm.write {
                    dog?.name = nameTextField.text!
                    dog?.profile = (dogImage.image?.pngData())!
                    dog?.breed = selectedDogBreed
                    dog?.age = dogBirthday
                    dog?.favouriteToy = toyTextField.text
                    dog?.favouriteTreat = treatTextField.text
                }
            } catch {
                print("Error saving modified dog, \(error)")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func archiveNewDog(name: String, image: UIImage, age: Int16, breed: String, isFemale: Bool, favouritToy: String, favouriteTreat: String) {
        
        do {
            try realm.write {
                let newDog = Dog()
                newDog.name = name
                newDog.profile = image.pngData()!
                newDog.age = dogBirthday
                newDog.breed = breed
                newDog.isFemale = isFemale
                newDog.favouriteToy = favouritToy
                newDog.favouriteTreat = favouriteTreat
            }
        } catch {
            print("Error saving new Dog, \(error)")
        }
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


