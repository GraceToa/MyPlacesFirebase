//
//  ProfileViewController.swift
//  MyPlaces
//
//  Created by GraceToa on 24/03/2019.
//  Copyright © 2019 Grace Toa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MapKit
import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var country: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadUser()
    }
    
    
    // MARK:- Load data User from Firebase
    
    func loadUser()  {

        guard let idFB = Auth.auth().currentUser?.uid else {
            return
        }
        self.email.text = Auth.auth().currentUser?.email
        
        ref.child(idFB).child("about").observe(DataEventType.value, with: {(snapshot) in
        
            print(snapshot.value as Any)
     
            if let dictionary = snapshot.value as? NSDictionary {
                
                if let username = dictionary["username"] as? String {
                    self.username.text = username
                }
                
                if let country = dictionary["country"] as? String {
                    self.country.text = country
                }
                
                if let urlImageFB = dictionary["image"] as? String {
                    Storage.storage().reference(forURL: urlImageFB).getData(maxSize: 5 * 1024 * 1024, completion: {  (data, error) in
                        if  let error = error?.localizedDescription {
                            print("error give image firebase", error)
                        }else{
    
                            self.image.image = UIImage(data: data!)
                            self.image.layer.borderWidth = 4
                            self.image.layer.borderColor = UIColor.white.cgColor
                            self.image.layer.masksToBounds = false
                            self.image.layer.cornerRadius = self.image.frame.height/2
                            self.image.clipsToBounds = true
    
                        }
                    })
                }
            }
        })
    }
}
