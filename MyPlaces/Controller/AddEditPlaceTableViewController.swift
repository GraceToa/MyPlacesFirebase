//
//  AddEditPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Grace Toa on 24/10/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//  UITextFieldDelegate.- protocol le dice al compilador que puede acutar como un delegado de campo de texto válido, esto significa que puede implementar métodos de protocolo para manejar entrada de texto

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddEditPlaceTableViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var place: Place?
    
    @IBOutlet weak var checkImg: UIImageView!
    var img = false
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var imgPickerView: UIImageView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var latitudeMap: CLLocationDegrees! = 0.0
    var longitudeMap: CLLocationDegrees! = 0.0
    
    var ref: DatabaseReference!
    var idUserFB = ""
    var image: UIImage?
    var imageURL = ""
    var idPlaceFB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        ref = Database.database().reference()
        idUserFB = (Auth.auth().currentUser?.uid)!
 
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "titulB.png"))
        addLocationButton.layer.cornerRadius = 12
        
        //edit place
        if let place = place {
            navigationItem.title = place.name
            idPlaceFB = place.id!
            nameTextField.text = place.name
            descriptionTextField.text = place.descriptionP
            latitudeMap = place.coordinate.latitude
            longitudeMap = place.coordinate.longitude
            imageURL = place.image
            loadImageFB(imageURL: imageURL)
        }
    }
    
    // MARK:- Add Picture
    
    @IBAction func cameraBtn(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryBtn(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK:- UIImagePickercontrollerDelegate methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageTake = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgPickerView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgPickerView.contentMode = .scaleAspectFill
        self.imgPickerView.clipsToBounds = true
        image = imageTake!
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Write or edit data Firebase

    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        let id = ref.childByAutoId().key
        //load library or camera
        if image != nil {
            let storage = Storage.storage().reference()
            let imgName = UUID()//esto nos genera un id
            let directory = storage.child("images/\(imgName)")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let imageData = image!.jpegData(compressionQuality: 0.25)
            
            directory.putData(imageData!, metadata: metaData, completion: {(data,error)in
                if error == nil {
                    if self.imageURL != "" {
                        //edit place replace image
                        let deleteImgFB = Storage.storage().reference(forURL: self.imageURL)
                        deleteImgFB.delete(completion: nil)
                        
                        let fields = ["id": self.idPlaceFB,"name": self.nameTextField.text!, "category": self.descriptionTextField.text!, "image":String(describing: directory),"latitude":self.latitudeMap as Any, "longitude": self.longitudeMap as Any] as [String : Any]
                        self.ref.child(self.idUserFB).child("places").child(self.idPlaceFB).setValue(fields)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabs")
                        self.present(vc!, animated: true, completion: nil)
                    }else{
                        //create new Place
                        let fields = ["id": id!,"name": self.nameTextField.text!, "category": self.descriptionTextField.text!, "image":String(describing: directory),"latitude":self.latitudeMap as Any, "longitude": self.longitudeMap as Any] as [String : Any]
                        self.ref.child(self.idUserFB).child("places").child(id!).setValue(fields)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabs")
                        self.present(vc!, animated: true, completion: nil)                    }
                    
                }else{
                    if let error = error?.localizedDescription{
                        print("error Load image in firebase",error)
                    }else{
                        print("error in code")
                    }
                }
            })
        }
        else{
            //edit place, not add image
            if self.imageURL != "" {
                let fields = ["id": self.idPlaceFB,"name": self.nameTextField.text!, "category": self.descriptionTextField.text!, "image": self.imageURL,"latitude":self.latitudeMap as Any, "longitude": self.longitudeMap as Any] as [String : Any]
                self.ref.child(self.idUserFB).child("places").child(self.idPlaceFB).setValue(fields)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabs")
                self.present(vc!, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alert¡¡", message: "You have enter an image¡", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func unwindFromMapViewController(sender: UIStoryboardSegue) {
         if let sourceViewController = sender.source as? LocationViewController{
            if sourceViewController.latitude != nil {
                latitudeMap = sourceViewController.latitude
            }else{
                latitudeMap = 0.0
            }
            if sourceViewController.longitude != nil {
                longitudeMap = sourceViewController.longitude
            }else{
                longitudeMap = 0.0
            }
            if img == false{
                self.checkImg.image = UIImage(named: "check.png")
            }
        }
    }
    
    // MARK:- Load Image from Firebase
    
    func loadImageFB(imageURL: String)  {
        Storage.storage().reference(forURL: imageURL).getData(maxSize: 5 * 1024 * 1024, completion: {  (data, error) in
            if  let error = error?.localizedDescription {
                print("error give image firebase", error)
            }else{
                self.imgPickerView.image = UIImage(data: data!)
                self.imgPickerView.layer.borderWidth = 4
                self.imgPickerView.layer.borderColor = UIColor.white.cgColor
                self.imgPickerView.layer.masksToBounds = false
                self.imgPickerView.clipsToBounds = true
            }
        })
    }
    
    private func updateSaveButtonState(){
        let textD = descriptionTextField.text ?? ""
        let textN = nameTextField.text ?? ""
        doneBtn.isEnabled = !textD.isEmpty
        doneBtn.isEnabled = !textN.isEmpty
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}

