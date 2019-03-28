//
//  LocationViewController.swift
//  MyPlaces
//
//  Created by Grace Toa on 08/12/2018.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController,CLLocationManagerDelegate  {
    
    //MARK: CLLocationCoordinate2D properties
    let locManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    //MARK: Outlet properties
    @IBOutlet weak var map: MKMapView!
    
    //MARK: variables
    var buttonIsHidden: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()//permisos info.plis
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.startUpdatingLocation()
        
    }
    
    
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
    

    
    //MARK: actions
    //Recoge la localización del GPS y envia los datos AddEditPlace....
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddEditPlaceTableViewController {
            destination.latitudeMap = latitude
            destination.longitudeMap = longitude
            
        }
    }

}
