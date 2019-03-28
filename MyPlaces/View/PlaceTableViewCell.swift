//
//  PlaceTableViewCell.swift
//  MyPlaces
//
//  Created by Grace Toa on 21/10/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    


    //MARK: IBOutlets
    @IBOutlet weak var namePlaceLabel: UILabel!
    
    @IBOutlet weak var descriptionPlaceLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet{
            backgroundImageView.layer.cornerRadius = 15
        }
    }

    @IBOutlet weak var imagePlace: UIImageView!{
        didSet{
            imagePlace.layer.borderWidth = 3
            imagePlace.layer.masksToBounds = true
            imagePlace.layer.borderColor = UIColor.white.cgColor
            imagePlace.layer.cornerRadius = imagePlace.frame.height/2
            imagePlace.clipsToBounds = true
            
        }
    }
    
    func bind(place: Place){
       let imgDefault =  ManagerPlaces.shared.loadImgTest()
        namePlaceLabel.text = place.name
        descriptionPlaceLabel.text = place.descriptionP
        imagePlace.image = UIImage(data: place.image ?? imgDefault )
    }

}
