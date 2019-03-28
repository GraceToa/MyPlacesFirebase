//
//  Place.swift
//  MyPlaces
//
//  Created by Grace Toa on 30/9/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import MapKit


class Place: NSObject, Codable{
    
    enum PlaceKeys: String, CodingKey {
        case name = "name"
        case descriptionP = "description"
        case image = "image"
        case latitude = "latitude"
        case longitude = "longitude"
    }
 
    required  convenience init(from: Decoder)throws{
        let container = try from.container(keyedBy: PlaceKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let  descriptionP = try container.decode(String.self, forKey: .descriptionP)
        let image = try container.decode(Data?.self, forKey: .image)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let coordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(name:name, descriptionP:descriptionP, image_in:image,location:coordinate2D)
        
    }
    
    func encode(to:Encoder)throws {
        var container = to.container(keyedBy: PlaceKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(descriptionP, forKey: .descriptionP)
        try container.encode(image, forKey: .image)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)

    }
    
    /*enumeración tipo de datos que permiten definir una lista de valores posibles*/
    enum PlaceTypes{
        case genericPlace
        case touristcPlace
    }
    
 
    
    //MARK: Properties
    
    var id: String = UUID().uuidString
    var type: PlaceTypes = .genericPlace
    var name: String?
    var descriptionP: String?
    var location: CLLocationCoordinate2D!
    var image: Data?
    
  
    
    //MARK: Initialization
//
    override init(){
        self.id = UUID().uuidString
    }

    init(name:String?,descriptionP:String?, image_in:Data?,location: CLLocationCoordinate2D) {
        self.id = UUID().uuidString
        self.name = name
        self.descriptionP = descriptionP
        self.image = image_in
        self.location = location
    }  

}//end class Place


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

