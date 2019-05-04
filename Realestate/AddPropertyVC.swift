//
//  AddPropertyVC.swift
//  Realestate
//
//  Created by nic on 30/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit
import ImagePicker


class AddPropertyVC: UIViewController, ImagePickerDelegate {
   
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topvView: UIView!
    @IBOutlet weak var referenceCodeTF: UITextField!
    @IBOutlet weak var bathroomTF: UITextField!
    @IBOutlet weak var roomsTF: UITextField!
    @IBOutlet weak var propertySizeTF: UITextField!
    @IBOutlet weak var balconySizeTF: UITextField!
    @IBOutlet weak var parkingTF: UITextField!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var advertisementTypeTF: UITextField!
    @IBOutlet weak var availableFromTF: UITextField!
    @IBOutlet weak var buildYearTF: UITextField!
    @IBOutlet weak var propertyTypeTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    // Switches
    @IBOutlet weak var tilteDeedSW: UISwitch!
    @IBOutlet weak var centralHeatingSW: UISwitch!
    @IBOutlet weak var solarWaterHeatingSW: UISwitch!
    @IBOutlet weak var storeRoomSW: UISwitch!
    @IBOutlet weak var airConditionerSW: UISwitch!
    @IBOutlet weak var furnishedSW: UISwitch!
    
    
    var user: FBUser?
    var titleDeadSWValue = false
    var centralHeatingSWValue = false
    var solarWaterHeatingSWValue = false
    var storeRoomSWValue = false
    var airConditionerSWValue = false
    var furnishedSWValue = false
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topvView.frame.size.height)
        
        
        
        
    
    }
    
    
    // MARK: IBactions
    //buttons
    @IBAction func camaraBTN(_ sender: Any) {
    }
    @IBAction func saveBTN(_ sender: Any) {
        user = FBUser.currentUser()!
        
        if !user!.isAgent{
            // check if user can post
            save()
            
            
        }else{
            
            save()
        }
        
    
    }
    @IBAction func currentLocationBTN(_ sender: Any) {
    }
    @IBAction func mapKitBTN(_ sender: Any) {
    }
    
    // MARK: Helper Function
    func save(){
        if titleTF.text != "" && referenceCodeTF.text != "" && advertisementTypeTF.text != "" && propertyTypeTF.text != "" && priceTF.text != ""{
            var newProperty = Property()
            newProperty.referenceCode = referenceCodeTF.text!
            newProperty.ownerId = user?.objectID
            newProperty.title = titleTF.text!
            newProperty.advertisementType = advertisementTypeTF.text!
            newProperty.price = Int(priceTF.text!)!
            newProperty.propertyType = propertyTypeTF.text!
            
            if balconySizeTF.text != ""{
                newProperty.balconySize = Double(balconySizeTF.text!)!
            }
            if bathroomTF.text != ""{
                newProperty.numberOfBathrooms = Int(bathroomTF.text!)!
            }
            if buildYearTF.text != ""{
                newProperty.buildYear = buildYearTF.text!
            }
            if parkingTF.text != ""{
                newProperty.parking = Int(parkingTF.text!)!
            }
            if roomsTF.text != ""{
                newProperty.numberOfRooms = Int(roomsTF.text!)!
            }
            if propertySizeTF.text != ""{
                newProperty.size = Double(propertySizeTF.text!)!
            }
            if addressTF.text != ""{
                newProperty.address = addressTF.text
            }
            if cityTF.text != ""{
                newProperty.city = cityTF.text
            }
            if availableFromTF.text != ""{
                newProperty.availableFrom = availableFromTF.text
            }
            if floorTF.text != ""{
                newProperty.floor = Int(floorTF.text!)!
            }
            if descriptionTV.text != "" && descriptionTV.text != "Description"{
                newProperty.propertyDescription = descriptionTV.text!
            }
            
            newProperty.titleDeeds = titleDeadSWValue
            newProperty.centralHeating = centralHeatingSWValue
            newProperty.solarWaterHeating = solarWaterHeatingSWValue
            newProperty.airConditioning = airConditionerSWValue
            newProperty.storeRoom = storeRoomSWValue
            newProperty.isFurnished = furnishedSWValue
            
            newProperty.saveProperty()
            ProgressHUD.showSuccess("Saved")
            //check for property images
            
            // create new property
        }else{
            ProgressHUD.showError("WWWWW:::: Error: Missing required fields")
    
        }
        
        
    }
    
    
    // SWitches
    @IBAction func titleDeedSW(_ sender: Any) {
        titleDeadSWValue = !titleDeadSWValue
    }
    @IBAction func centralHeatingSW(_ sender: Any) {
        centralHeatingSWValue = !centralHeatingSWValue
    }
    @IBAction func solarWaterHeatingSW(_ sender: Any) {
        solarWaterHeatingSWValue = !solarWaterHeatingSWValue
    }
    @IBAction func storeRoomSW(_ sender: Any) {
        storeRoomSWValue = !storeRoomSWValue
    }
    @IBAction func airConditionerSW(_ sender: Any) {
        airConditionerSWValue = !airConditionerSWValue
    }
    @IBAction func furnishedSW(_ sender: Any) {
        furnishedSWValue = !airConditionerSWValue
    }
    
    
    // MARK: Image Picker Delegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }

    
    
    
}
