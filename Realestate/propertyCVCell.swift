//
//  propertyCVCell.swift
//  Realestate
//
//  Created by nic on 25/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit

@objc protocol PropertyCollectionViewDeleagate {
    @objc optional func didClickStarBtn(property: Property)
    @objc optional func didClickMenuBtn(property: Property)
    
}

class propertyCVCell: UICollectionViewCell {
    
    @IBOutlet weak var propertyIV: UIImageView!
    
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var favoritesBTN: UIButton!
    
    @IBOutlet weak var topAdIV: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var soldIV: UIImageView!
    
    @IBOutlet weak var roomLBL: UILabel!
    @IBOutlet weak var bathroomLBL: UILabel!
    @IBOutlet weak var parkingLBL: UILabel!
    
    @IBOutlet weak var priceLBL: UILabel!
    
    
    var delegate: PropertyCollectionViewDeleagate?
    
    
    var property: Property!
    
    func generateCell(property: Property){
        self.property = property
        titleLBL.text = property.title
        roomLBL.text = "\(String(describing: property.numberOfRooms))"
        bathroomLBL.text = "\(property.numberOfBathrooms)"
        parkingLBL.text = "\(property.parking)"
        priceLBL.text = "\(property.price)"
        priceLBL.sizeToFit()
        
        // top ad
        if property.inTopUntil != nil && property.inTopUntil! > Date() {
            topAdIV.isHidden = false
        }else{
            topAdIV.isHidden = true
        }
        
        // favorite property
        if self.favoritesBTN != nil{
            if FBUser.currentUser() != nil && (FBUser.currentUser()?.favortieProperties.contains(property.objectID!))!{
                self.favoritesBTN.setImage(UIImage(named: "starFilled"), for: .normal)
            }else{
                self.favoritesBTN.setImage(UIImage(named: "star"), for: .normal)
            }
        }
        
        // sold
        
        if property.isSold{
            soldIV.isHidden = false
        }else{
            soldIV.isHidden = true
            
        }
        
        // image note
        if property.imageLinks != "" && property.imageLinks != nil{
            // download images
            
            downloadImages(urls: property.imageLinks!) { (images) in
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.propertyIV.image = images.first!
                
            }
            
        }else{
            
            self.propertyIV.image = UIImage(named: "propertyPlaceholder")
            self.loadingIndicator.isHidden = true
            
        }
    }
    
    
    
    @IBAction func likeBTNPressed(_ sender: Any) {
        
        delegate!.didClickStarBtn!(property: property)
        
    }
    
}
