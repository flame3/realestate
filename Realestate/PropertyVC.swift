//
//  PropertyVC.swift
//  Realestate
//
//  Created by nic on 6/5/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit
import MapKit

class PropertyVC: UIViewController{

    @IBOutlet weak var imageSV: UIScrollView!
    @IBOutlet weak var mainSV: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var shortInfoLBL: UILabel!
    @IBOutlet weak var propertyTypeLBL: UILabel!
    @IBOutlet weak var availableDate: UILabel!
    @IBOutlet weak var furnishedLBL: UILabel!
    @IBOutlet weak var storeRoomLBL: UILabel!
    @IBOutlet weak var airConditionLBL: UILabel!
    @IBOutlet weak var solarWaterHeatingLBL: UILabel!
    @IBOutlet weak var centrqlHeatingLBL: UILabel!
    @IBOutlet weak var titleDeedsLBL: UILabel!
    @IBOutlet weak var constructionYearLBL: UILabel!
    @IBOutlet weak var floorLBL: UILabel!
    @IBOutlet weak var parkingLBL: UILabel!
    @IBOutlet weak var bathroomLBL: UILabel!
    @IBOutlet weak var balconySizeLBL: UILabel!
    @IBOutlet weak var callBackBTN: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var property: Property!
    var propertyCoordinates: CLLocationCoordinate2D?
    var imageArray: [UIImage] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPropertyImages()
        setupUI()

        mainSV.contentSize = CGSize(width: view.frame.width, height: 1000)
        
    }
    
    // MARK: - Helpers
    func getPropertyImages(){
//        if property.imageLinks != "" && property.imageLinks != nil{
//            downloadImages(urls: property.imageLinks { (images) in
//                self.imageArray = images as! [UIImage]
//                self.setSlideShow()
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
//
//            })
        if property.imageLinks != nil{
            print("succecful")
        } else{
            // we have no images
            
            self.imageArray.append(UIImage(named: "propertyPlaceholder")!)
            self.setSlideShow()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        
        }
    
    func setSlideShow(){
        for i in 0..<imageArray.count{
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFill
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: imageSV.frame.width, height: imageSV.frame.height)
            
            imageSV.contentSize.width = imageSV.frame.width * CGFloat(i)
            imageSV.addSubview(imageView)
            
            
            
            
        }

    }
    
    func setupUI(){
        
        if FBUser.currentUser() != nil{
            self.callBackBTN.isEnabled = true
        }
        //set propertiess
        titleLBL.text = property.title!
        priceLBL.text = "\(property.price)"
        shortInfoLBL.text = "\(property.size) m2 - \(property.numberOfRooms) Bedroom(s)"
        propertyTypeLBL.text = property.propertyType
        furnishedLBL.text = property.isFurnished ? "YES" : "NO"
        storeRoomLBL.text = property.storeRoom ? "YES" : "NO"
        airConditionLBL.text = property.airConditioning ? "YES" : "NO"
        solarWaterHeatingLBL.text = property.solarWaterHeating ? "YES" : "NO"
        centrqlHeatingLBL.text = property.centralHeating ? "YES" : "NO"
        titleDeedsLBL.text = property.titleDeeds ? "YES" : "NO"
        furnishedLBL.text = property.isFurnished ? "YES" : "NO"
        constructionYearLBL.text = (property.buildYear != nil) ? "YES" : "NO"
        parkingLBL.text = "\(property.parking)"
        floorLBL.text =  "\(property.floor)"
        bathroomLBL.text = "\(property.numberOfBathrooms)"
        balconySizeLBL.text = "\(property.balconySize)"
        availableDate.text = property.availableFrom
        
        // optional
        descriptionLBL.isHidden = true
        descriptionTF.isHidden = true
        addressLBL.isHidden = true
        mapView.isHidden = true
        
        if property.propertyDescription != nil{
            descriptionLBL.isHidden = false
            descriptionTF.isHidden = false
            descriptionTF.text = property.propertyDescription
        }
        
        if property.address != nil && property.address != ""{
            addressLBL.isHidden = false
            addressLBL.text = property.address
        
        }
        
        if property.latitutude != 0 && property.latitutude != nil{
            
            mapView.isHidden = false
            propertyCoordinates = CLLocationCoordinate2D(latitude: property.latitutude!, longitude: property.longitutude!)
            
            let annotaion = MKPointAnnotation()
            
            annotaion.title = property.title
            annotaion.subtitle = "\(property.numberOfRooms) bedroom \(property.propertyType!)"
            annotaion.coordinate = propertyCoordinates!
            self.mapView.addAnnotation(annotaion)
            
        }
        
        mainSV.contentSize = CGSize(width: view.frame.width, height: view.frame.height)




        
    }
    

   
    // MARK: - IBaction
    
    @IBAction func backBTNPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callBackBTNPressed(_ sender: Any) {
    
    
    }
    
    
    
}
