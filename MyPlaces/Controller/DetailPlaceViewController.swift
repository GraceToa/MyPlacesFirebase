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

class DetailPlaceViewController: UIViewController,CLLocationManagerDelegate  {
    
    //MARK: variables
    var place: Place?
    
    //MARK: Outlet properties
    @IBOutlet weak var nameP: UILabel!
    @IBOutlet weak var descriptionP: UILabel!
    @IBOutlet weak var imageP: UIImageView!
    
    //MARK: Outlet MapKit
    @IBOutlet weak var map: MKMapView!
    
    //MARK: CLLocationCoordinate2D properties
    let locManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = place?.name
        imageP.layer.borderColor = UIColor.green.cgColor

        if let place = place {
            nameP.text = "Location: \( place.name ?? "")"
            descriptionP.text = place.descriptionP
            descriptionP.sizeToFit()
            let imgDefault =  ManagerPlaces.shared.loadImgTest()
            imageP.image = UIImage(data: place.image ?? imgDefault )
        }
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()//permisos info.plis
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.startUpdatingLocation()
        
    }
    
    // MARK: - se envia objeto Place para su edición
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dc = segue.destination as? AddEditPlaceTableViewController{
            dc.place = place
        }
    }
    
    //MARK: acction buttons
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "ShowPlaceEdit", sender: self)
    }
    
    //MARK: CoreLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion ( center: location, span: span)
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        manager.stopUpdatingLocation()
    }

}
