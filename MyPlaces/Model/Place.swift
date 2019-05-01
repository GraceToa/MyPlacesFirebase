//
//  Place.swift
//  MyPlaces
//
//  Created by Grace Toa on 30/9/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import MapKit


class Place: NSObject{
    
    // MARK:- Properties
    
    var id: String?
    var name: String?
    var descriptionP: String?
    var location: CLLocationCoordinate2D!
    var image: String


    init(id:String?, name:String?,descriptionP:String?, image_in:String,location: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.descriptionP = descriptionP
        self.image = image_in
        self.location = location
    }
}

// MARK:- CLLocationCoordinate2D method

extension Place: MKAnnotation{
    var coordinate: CLLocationCoordinate2D{
        return location
    }
    
    var title: String?{
        return name
    }
    var subtitle: String?{
        return descriptionP
    }
}

