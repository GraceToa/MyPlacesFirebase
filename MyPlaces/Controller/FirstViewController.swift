//
//  FirstViewController.swift
//  MyPlaces Firebase Demo
//  Los métodos que vienen definidos en los protocolos del Delegate y DataSource, implementamos
//  Created by Grace Toa on 26/9/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirstViewController: UITableViewController {
  
    //MARK: images Background
    var images:[UIImage] = [UIImage(named: "fondo1.png")!,UIImage(named: "fondo2.png")!,UIImage(named: "fondo3.png")!,UIImage(named: "fondo4.png")!,UIImage(named: "fondo5.png")!,UIImage(named: "fondo6.png")!,UIImage(named: "fondo7.png")!]
    
    @IBOutlet var table: UITableView!
    
    var ref: DatabaseReference!
    var idUserFB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavBarImage()
        addTabBar()
        let view = self.view as! UITableView
        view.delegate = self
        view.dataSource = self
        ref = Database.database().reference()
        idUserFB = (Auth.auth().currentUser?.uid)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ManagerPlaces.shared.cleanPlaces()
        loadDatesFB()
    }
 
    // MARK:- Table view data source
    
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManagerPlaces.shared.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let placeCell = ManagerPlaces.shared.getItemAt(position: indexPath.item)!
        cell.namePlaceLabel.text = placeCell.name
        cell.descriptionPlaceLabel.text = placeCell.descriptionP
        cell.backgroundImageView.image = randomImageCell()
        let urlPhoto = placeCell.image

         Storage.storage().reference(forURL: urlPhoto).getData(maxSize: 5 * 1024 * 1024, completion: {  (data, error) in
            if  let error = error?.localizedDescription {
                print("error load image Firebase", error)
            }else{
                cell.imagePlace.image = UIImage(data: data!)
                cell.imagePlace.makeRounded()
            }
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPlaceDetail", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action,indexPath) in
            let placeDelete = ManagerPlaces.shared.getItemAt(position: indexPath.row)
            let id = placeDelete?.id
            let imageD = placeDelete?.image
            self.ref.child(self.idUserFB).child("places").child(id!).setValue(nil)
            let imgDelete = Storage.storage().reference(forURL: imageD!)
            imgDelete.delete(completion: nil)
            ManagerPlaces.shared.remove(placeDelete!)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [delete]
    }

    
    // MARK:-  Load data from Firebase
    
    func loadDatesFB() {
        guard let idFB = Auth.auth().currentUser?.uid else {
            return
        }
        ref.child(idFB).child("places").observe(DataEventType.value, with: {(snapshot) in
            var itemsPlaces = [Place]()
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let dictionary = child.value as! NSDictionary
                let id = dictionary["id"] as? String
                let name = dictionary["name"] as? String
                let category = dictionary["category"] as? String
                let url = dictionary["image"] as? String
                let latitude = dictionary["latitude"] as? Double
                let longitude = dictionary["longitude"] as? Double
                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                
                let place = Place(id: id, name: name, descriptionP: category, image_in: url!, location: coordinate)
                itemsPlaces.append(place)
            }
            ManagerPlaces.shared.places = itemsPlaces
            self.table.reloadData()
        })

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlaceDetail" {
            if let id = tableView.indexPathForSelectedRow{
                let p = ManagerPlaces.shared.getPlaces()[id.row]
                let destin = segue.destination as! DetailPlaceViewController
                destin.place = p
            }
        }
    }

    
    // MARK:-  Navigation Bar, TabBar
    
    func addNavBarImage()  {
        let image = UIImage(named: "titulB.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
        let navBar = navigationController?.navigationBar
        navBar!.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.backgroundColor = .clear
        navBar!.setBackgroundImage(UIImage(named: "navBar.png")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
    }
    
    func addTabBar()  {
        let tabBar = tabBarController?.tabBar
        tabBar?.backgroundImage = UIImage(named: "tabBar.png")
        tabBar?.clipsToBounds = true
    }
    
    func randomImageCell() -> UIImage {
        let unsignedArrayCount = UInt32(images.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        let generatedImage:AnyObject = images[randomNumber]
        return (generatedImage as? UIImage)!
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowAddEditPlace", sender: self)
    }
    
    
    @IBAction func signOutUser(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "ShowLogin", sender: self)

        } catch let signOutError as NSError {
            print ("Error signing out", signOutError)
        }
    }
    
}

extension UIImageView {
    
    func makeRounded() {
        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
