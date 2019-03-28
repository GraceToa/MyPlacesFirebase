//
//  RegisterViewController.swift
//  MyPlaces
//
//  Created by GraceToa on 22/03/2019.
//  Copyright © 2019 Grace Toa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    
    //MARK: Variables
    var image = UIImage()
    var dataUser = "about"
    
    //MARK: Firebase
    var ref: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    //MARK: - Camera UIImagePickerController
    @IBAction func galeryBtn(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageTake = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = imageTake!
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func createAccountAction(_ sender: UIButton) {
        
        if emailTF.text == "" || passwordTF.text == "" || usernameTF.text == "" || countryTF.text == ""{
           
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!){
                (user,error)in
                
                if error == nil{
                    print("You have successfully signed up")
                   let idUserFB = (Auth.auth().currentUser?.uid)!
                    let storage = Storage.storage().reference()
                    let imgName = UUID()
                    let directory = storage.child("images/\(imgName)")
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    let imageData = self.image.jpegData(compressionQuality: 0.18)
                    
                    directory.putData(imageData!, metadata: metaData, completion: {(data,error)in
                        if error == nil {
                            print("load Ok")
                        }else{
                            if let error = error?.localizedDescription{
                                print("error Load image in firebase",error)
                            }else{
                                print("error in code")
                            }
                        }
                    })
                    
                    
                    let fields = ["username": self.usernameTF.text!,"country": self.countryTF.text!, "image":String(describing: directory)]
                    
                    self.ref.child(idUserFB).child(self.dataUser).setValue(fields)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabs")
                    self.present(vc!, animated: true, completion: nil)
                    
                }else{
                    if let error = error?.localizedDescription{
                        let alertController = UIAlertController(title: "Error", message: "The password must be 6 characters long or more", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        print("error firebase Sign Up",error)
                    }else{
                        print("error codigo")
                    }
                }
            }
        }
        
    }
  

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  
    
}
