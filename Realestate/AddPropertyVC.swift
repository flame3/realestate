//
//  AddPropertyVC.swift
//  Realestate
//
//  Created by nic on 30/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit
import ImagePicker


class AddPropertyVC: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate, ImagePickerDelegate, MapViewDelegate {
    
    
    
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
    
    var yearArray: [Int] = []
    var datePicker: UIDatePicker!
    var propertyTypePicker = UIPickerView()
    var advertisementTypePicker = UIPickerView()
    var yearPicker = UIPickerView()
    
    var locationManager: CLLocationManager?
    var locationCoordinates: CLLocationCoordinate2D?
    
    var activeField: UITextField?
    
    
    var propertyImages: [UIImage] = []
    
    
    var user: FBUser?
    var titleDeadSWValue = false
    var centralHeatingSWValue = false
    var solarWaterHeatingSWValue = false
    var storeRoomSWValue = false
    var airConditionerSWValue = false
    var furnishedSWValue = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        locationManagerStop()
    }
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupYearArray()
        
        // setting delegates to self due to pickers
        referenceCodeTF.delegate = self
        bathroomTF.delegate = self
        roomsTF.delegate = self
        propertySizeTF.delegate = self
        balconySizeTF.delegate = self
        parkingTF.delegate = self
        floorTF.delegate = self
        addressTF.delegate = self
        cityTF.delegate = self
        countryTF.delegate = self
        advertisementTypeTF.delegate = self
        availableFromTF.delegate = self
        buildYearTF.delegate = self
        propertyTypeTF.delegate = self
        priceTF.delegate = self
        titleTF.delegate = self
        
        setupPickers()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

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
        locationManagerStart()
    }
    
    @IBAction func mapKitBTN(_ sender: Any) {
        //show map so the user can pick a location
        
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map") as! MapVC
        
        mapView.delegate = self
        
        self.present(mapView, animated: true, completion: nil)
        
    }
    
    // MARK: Helper Function
    func setupYearArray(){
        for i in 1950...2030{
            yearArray.append(i)
        }
        yearArray.reverse()
    }
    
    func save(){
        if titleTF.text != "" && referenceCodeTF.text != "" && advertisementTypeTF.text != "" && propertyTypeTF.text != "" && priceTF.text != ""{
            
            
            var newProperty = Property()
            
            ProgressHUD.show("Saving...")
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
            if locationCoordinates != nil{
                newProperty.latitutude = locationCoordinates!.latitude
                newProperty.longitutude = locationCoordinates!.longitude
            }
            
            
            
            newProperty.titleDeeds = titleDeadSWValue
            newProperty.centralHeating = centralHeatingSWValue
            newProperty.solarWaterHeating = solarWaterHeatingSWValue
            newProperty.airConditioning = airConditionerSWValue
            newProperty.storeRoom = storeRoomSWValue
            newProperty.isFurnished = furnishedSWValue
            
            //check for property images
            
            if propertyImages.count != 0{
                uploadImages(images: propertyImages, userId: user!.objectID, referenceNum: newProperty.referenceCode!) { (linkString) in
                    newProperty.imageLinks = linkString
                    newProperty.saveProperty()
                    ProgressHUD.showSuccess("Saved")
                    self.dismissView()
                }
                
            }else{
                newProperty.saveProperty()
                ProgressHUD.showSuccess("Saved")
                self.dismissView()
            }
            
            // create new property
        }else{
            ProgressHUD.showError("WWWWW:::: Error: Missing required fields")
    
        }
        
        
    }
    
    func dismissView(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        present(vc, animated: true, completion: nil)
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
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = kMAXIMAGENUMBER
        
        present(imagePickerController, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        propertyImages = images
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: PickerView
    
    func setupPickers(){
        yearPicker.delegate = self
        propertyTypePicker.delegate = self
        advertisementTypePicker.delegate = self
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        
        toolBar.setItems([flexibleBar, doneButton], animated: true)
        buildYearTF.inputAccessoryView = toolBar
        buildYearTF.inputView = yearPicker
        
        availableFromTF.inputAccessoryView = toolBar
        availableFromTF.inputView = datePicker
        
        propertyTypeTF.inputAccessoryView = toolBar
        propertyTypeTF.inputView = propertyTypePicker
        
        advertisementTypeTF.inputAccessoryView = toolBar
        advertisementTypeTF.inputView = advertisementTypePicker
    }
    
    @objc func doneButtonPressed(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == propertyTypePicker{
            return propertyTypes.count
        }
        
        if pickerView == advertisementTypePicker{
            return advertisementTypes.count
        }
        
        if pickerView == yearPicker{
            return yearArray.count
            
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == propertyTypePicker{
            return propertyTypes[row]
        }
        
        if pickerView == advertisementTypePicker{
            return advertisementTypes[row]
        }
        
        if pickerView == yearPicker{
            return "\(yearArray[row])"
            
        }
        return ""
        

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var rowValue = row
        if pickerView == propertyTypePicker{
            if rowValue == 0{ rowValue = 1 }
            propertyTypeTF.text = propertyTypes[rowValue]

        }
        
        if pickerView == advertisementTypePicker{
            if rowValue == 0{ rowValue = 1 }
            advertisementTypeTF.text = advertisementTypes[rowValue]
        }
        
        
        if pickerView == yearPicker{
            buildYearTF.text = "\(yearArray[row])"
        }
        
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if activeField == availableFromTF{
            availableFromTF.text = "\(components.day!)\(components.month!)\(components.year!)"
        }
    }
    
    // MARK: UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       // textField = nil
    }
    
    // MARK: Location Manager
    
    func locationManagerStart(){
    
    if locationManager == nil{
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
    
    }
        locationManager?.startUpdatingLocation()
    }
    func locationManagerStop(){
        
        if locationManager != nil{
            locationManager!.stopUpdatingLocation()
        }
        
    
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get the location")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .restricted:
            
            break
        case .denied:
            locationManager = nil
            print("location denied")
            // show user a notification to enable location in settings
            ProgressHUD.showError("Please enable location from the settings")
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationCoordinates = locations.last!.coordinate
    }
    
    //MARK: Map View Delegate
    
    func didFinishWith(coordinate: CLLocationCoordinate2D) {
        self.locationCoordinates = coordinate   
    }
}
