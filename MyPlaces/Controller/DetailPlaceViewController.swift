//
//  DetailPlaceViewController.swift
//  MyPlaces
//
//  Created by Grace Toa on 7/11/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseStorage


class DetailPlaceViewController: UIViewController,CLLocationManagerDelegate  {
    
    var place: Place?
    
    @IBOutlet weak var descriptionP: UILabel!
    @IBOutlet weak var imageP: UIImageView!
    @IBOutlet weak var map: MKMapView!
    
    var ref: DatabaseReference!
    var idUserFB = ""
    var imageURL = ""
    
    let locManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = place?.name
        
        descriptionP.text = place?.descriptionP
        latitude = place?.coordinate.latitude
        longitude = place?.coordinate.longitude
        imageURL = (place?.image)!
        loadImageFB(imageURL: imageURL)
        
        let p = MKPointAnnotation()
        p.title = place?.title
        p.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(p)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dc = segue.destination as? AddEditPlaceTableViewController{
            dc.place = place
        }
    }
    
    // MARK:- Load data from Firebase
    
    func loadImageFB(imageURL: String)  {
        Storage.storage().reference(forURL: imageURL).getData(maxSize: 5 * 1024 * 1024, completion: {  (data, error) in
            if  let error = error?.localizedDescription {
                print("error give image firebase", error)
            }else{
                self.imageP.image = UIImage(data: data!)
                self.imageP.layer.borderWidth = 4
                self.imageP.layer.borderColor = UIColor.white.cgColor
                self.imageP.layer.masksToBounds = false
                self.imageP.clipsToBounds = true
            }
        })
    }
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "ShowPlaceEdit", sender: self)
    }
}
