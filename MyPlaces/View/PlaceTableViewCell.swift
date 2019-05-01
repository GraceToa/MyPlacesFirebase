//
//  PlaceTableViewCell.swift
//  MyPlaces
//
//  Created by Grace Toa on 21/10/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    

    @IBOutlet weak var namePlaceLabel: UILabel!
    
    @IBOutlet weak var descriptionPlaceLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet{
            backgroundImageView.layer.cornerRadius = 15

        }
    }
    
    @IBOutlet weak var imagePlace: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  

}
