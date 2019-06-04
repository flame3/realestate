//
//  MapVC.swift
//  Realestate
//
//  Created by nic on 6/5/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewDelegate{
    func didFinishWith(coordinate: CLLocationCoordinate2D)
}

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: MapViewDelegate?
    var pinCoordinates: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongTouch))
        
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        

        //  need to get coordinates from goolge maps
        var region = MKCoordinateRegion()
        region.center.latitude = 45.55
        region.center.longitude = 14.54
        region.span.latitudeDelta = 100
        region.span.longitudeDelta = 100
        mapView.setRegion(region, animated: true)
        
    }
    


    
    // MARK: IBactions
    
    @IBAction func doneBtn(_ sender: Any) {
        
        if mapView.annotations.count == 1 && pinCoordinates != nil{
            delegate?.didFinishWith(coordinate: pinCoordinates!)
            self.dismiss(animated: true, completion: nil)
            
        }else{
            self.dismiss(animated: true, completion: nil    )
        }
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Function
    
    @objc func handleLongTouch(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            let location = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            
            // drop a pin
            dropPin(coordinate: coordinates)
            
        }
    
    }
    
    func dropPin(coordinate: CLLocationCoordinate2D){
        
        // remove all existing pins from the map
        mapView.removeAnnotations(mapView.annotations)
        
        pinCoordinates = coordinate
        
        let annotations = MKPointAnnotation()
        annotations.coordinate = coordinate
        
        self.mapView.addAnnotation(annotations)
        
    }
    
}
