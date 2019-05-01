//
//  LoginViewController.swift
//  MyPlaces
//
//  Created by GraceToa on 22/03/2019.
//  Copyright © 2019 Grace Toa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    // MARK:- UISegmentControl method
  
    @IBAction func segmControl(_ sender: UISegmentedControl) {
        
        self.segControl.clipsToBounds = true
        self.segControl.layer.borderWidth = 1
        self.segControl.layer.cornerRadius =  15.0
  
        if segControl.selectedSegmentIndex == 0{
            if self.emailTF.text == "" || passwordTF.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }else{
                signIn(email: emailTF.text!, password: passwordTF.text!)
            }
        }
        if segControl.selectedSegmentIndex == 1{
            self.performSegue(withIdentifier: "ShowRegister", sender: self)
        }
    }
    
    // MARK:- Authentication
    
    func signIn(email:String, password:String)  {
        Auth.auth().signIn(withEmail: email, password: password){
            (user,error)in
            
            if user != nil{
                self.performSegue(withIdentifier: "ShowTabs", sender: self)
            }else{
                if let error = error?.localizedDescription{
                    print("error firebase Sign In",error)
                }else{
                    print("error code")
                }
            }
        }
    }
    

    
    
    //mientras no le demos al boton exit seguiremos logueados
    //osea la app se volvera abrir en el mismo punto donde lo dejamos
    func login()  {
        Auth.auth().addStateDidChangeListener { (auth,user) in
            if user == nil {
                print("You need autenticacion¡")
            }else{
                self.performSegue(withIdentifier: "ShowTabs", sender: self)
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
