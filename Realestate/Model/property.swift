//
//  property.swift
//  Realestate
//
//  Created by nic on 30/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import Foundation

@objcMembers
class Property: NSObject{
    var objectID: String?
    var referenceCode: String?
    var ownerId: String?
    var title: String?
    var numberOfRooms: Int = 0
    var numberOfBathrooms: Int = 0
    var size: Double = 0.0
    var balconySize: Double = 0.0
    var parking: Int = 0
    var floor: Int = 0
    var address: String?
    var city: String?
    var country: String?
    var propertyDescription: String?
    var latitutude: Double?
    var longitutude: Double?
    var advertisementType: String?
    var availableFrom: String?
    var imageLinks: String?   // should be text in backendless, unless text is to short
    var buildYear: String?
    var price: Int = 0
    var propertyType: String?
    var titleDeeds: Bool = false
    var centralHeating: Bool = false
    var solarWaterHeating: Bool = false
    var airConditioning: Bool = false
    var storeRoom: Bool = false
    var isFurnished: Bool = false
    var isSold: Bool = false
    var inTopUntil: Date?
    
                                // save property     Create Read Update Delete
    
    // MARK: Save functions
    func saveProperty(){
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.save(self)
        
        
    }
    
    func saveProperty(completion: @escaping (_ value: String)-> Void) {
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.save(self, response: { (result) in
            completion("Success")
        }, error: { (fault: Fault?) in
            completion(fault!.message)
        })
    }
    
    
                                // delete property
    // MARK: Delete function
    
    func deleteProperty(property: Property){
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.remove(property)
    }
    
    func deleteProperty(property: Property, completion: @escaping (_ value: String)-> Void){
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore?.remove(property, response: { (result) in
            completion("Success")
        }, error: { (fault: Fault?) in
            completion(fault!.message)
        })
    }
    
    
    
                                // retrieve property
    // MARK: Search function
    class func fetchRecentProperties(limitNumber: Int, completion: @escaping (_ properties: [Property?])-> Void){
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setSortBy(["inTopUntil DESC"])
        queryBuilder?.setPageSize(Int32(limitNumber))
        queryBuilder?.setOffset(0)
        
        
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.find(queryBuilder, response: { (backendlessProperties) in
            completion(backendlessProperties as! [Property])
        }, error: { (fault: Fault?) in
            print("WWWW: error couldnt get recent Properties \(String(describing: fault!.message))")
            completion([])
        })
    }
    
    class func fetchAllProperties(completion: @escaping (_ properties: [Property])->Void){
        let dataStore = backendless?.data.of(Property().ofClass())
        dataStore?.find({ (allProperties) in
            completion(allProperties as! [Property])
        }, error: { (fault: Fault?) in
            print("error couldnt get recent Properties \(String(describing: fault!.message))")
            completion([])
        })
        
        
    }
    
    class func fetchPropertiesWith(whereClause: String, completion: @escaping (_ properties: [Property])-> Void) {
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setSortBy(["inTopUntil DESC"])
        queryBuilder?.setWhereClause(whereClause)
        
        let dataStore =  backendless?.data.of(Property.ofClass())
        dataStore?.find(queryBuilder, response: { (allProperties) in
            completion(allProperties as! [Property])
        }, error: { (fault: Fault?) in
            print("error couldnt get recent properties\(String(describing: fault?.message))")
            completion([])
        })
        
    }
    
    
                                // modify property
    
    
}
