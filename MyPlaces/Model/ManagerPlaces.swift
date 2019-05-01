//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by Grace Toa on 30/9/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import MapKit
import CoreLocation


class ManagerPlaces{
    
    static let shared = ManagerPlaces()
    var places = [Place]()
    
    var latitudeMap: CLLocationDegrees! = 0.0
    var longitudeMap: CLLocationDegrees! = 0.0

    
    // MARK:- Private Methods
    
    func append(_ place: Place)  {
        places.append(place)
    }
    
    func getCount()->Int {
        return places.count;
    }
    
    func getItemAt(position:Int) -> Place? {
        //guard nos permite especificar alguna condición que debe cumplirse
        guard position < places.count else {return nil}
        return places[position];
    }
    
    func remove(_ place:Place){
        if let index = places.firstIndex(where: {$0.name == place.name}) {
            places.remove(at: index)
        }
    }

    func getPlaces() ->[Place] {
        return places
    }
    
    func cleanPlaces(){
        places.removeAll()
    }
    
 
}


