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

class ProfileViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var country: UILabel!
    
    //MARK: Firebase
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    var dataUser = "about"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadUser() 

    }
    
    func loadUser()  {

        guard let idFB = Auth.auth().currentUser?.uid else {
            return
        }
        self.email.text = Auth.auth().currentUser?.email
        handle = ref.child(idFB).observe(DataEventType.value, with: {(snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                let values = item.value as? [String: AnyObject]
                self.username.text = values!["username"] as? String
                self.country.text = values!["country"] as? String
                let urlImageFB = (values!["image"] as? String)!
                
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
        })
        
  

    }
    


}
