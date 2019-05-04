//
//  FBUser.swift
//  Realestate
//
//  Created by nic on 16/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit
import Firebase


class FBUser {
    let objectID: String
    var pushID: String?
    
    let createdAt: Date
    var updatedAt: Date
    
    var coins: Int
    var companyName: String
    var firstName: String
    var lastName: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var additionalPhoneNumber: String
    var isAgent: Bool
    var favortieProperties: [String]
    
    init(_objectID:String, _pushID:String?, _createdAt:Date, _updatedAt:Date, _firstName: String, _lastName: String, _avatar: String = "", _phoneNumber: String = "") {
        
        objectID = _objectID
        pushID = _pushID
        
        createdAt = _createdAt
        updatedAt = _updatedAt
        
        coins = 10
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + "" + _lastName
        avatar = _avatar
        isAgent = false
        companyName = ""
        favortieProperties = []
        
        phoneNumber = _phoneNumber
        additionalPhoneNumber = ""
    }
    
    
    
    init(_dictionary: NSDictionary) {
        
        objectID = _dictionary[kObjectId]  as! String
        pushID = _dictionary[kPUSHID] as? String
        
        
        
        if let created = _dictionary[kCreatedAt]{
            createdAt = dateFormatter().date(from: created as! String)!
        } else{
            createdAt = Date()
        }
        
        if let updated = _dictionary[kUpdatedAt]{
            updatedAt = dateFormatter().date(from: updated as! String)!
        } else{
            updatedAt = Date()
        }
        
        if let dCoin = _dictionary[kCOINS]{
            coins = dCoin as! Int
        }else{
            coins = 0
        }
        if let comp = _dictionary[kCompany]{
            companyName = comp as! String
        }else{
            companyName = ""
        }
        if let fname = _dictionary[kFIRSTNAME]{
            firstName = fname as! String
        }else{
            firstName = ""
        }
        if let lname = _dictionary[kLASTNAME]{
            lastName = lname as! String
        }else{
            lastName = ""
        }
        fullName = firstName + "" + lastName
        if let avat = _dictionary[kAVATAR]{
            avatar = avat as! String
        }else{
            avatar = ""
        }
        if let agent = _dictionary[kISAGENT]{
            isAgent = agent as! Bool
        }else{
            isAgent = false
        }
        if let phone = _dictionary[kPhone]{
            phoneNumber = phone as! String
        }else{
            phoneNumber = ""
        }
        if let addphone = _dictionary[kAddPhone]{
            additionalPhoneNumber = addphone as! String
        }else{
            additionalPhoneNumber = ""
        }
        if let favprop = _dictionary[kFAVORITEPROPERTIES]{
            favortieProperties = favprop as! [String]
        }else{
            favortieProperties = []
        }
        
    }
    
    class func currentID() -> String{
        return (Auth.auth().currentUser?.uid)!
        
    }
    class func currentUser() -> FBUser?{
        if Auth.auth().currentUser != nil{
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
                return FBUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    class func registerUserWith(email: String, password: String, firstname: String, lastname: String, completion: @escaping (_ error: Error?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            if error != nil{
                completion(error)
                return
            }
            let fUser = FBUser(_objectID: firUser!.user.uid, _pushID: "", _createdAt: Date(), _updatedAt: Date(), _firstName: firstname, _lastName: lastname)
            
            saveUserLocally(fbUser: fUser)
            // save to user defaults
            saveUserInBackground(fUser: fUser)
            // save to firebase
            
            completion(error)
        }
        
    }
    class func registerUserWith(phoneNum: String, verificationCode: String, completion: @escaping (_ error: Error?, _ shouldLogin: Bool)-> Void ) {
        let verificationID = UserDefaults.value(forKey: kVERIFICATIONCODE)
        let creditials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: creditials) { (firUser, error) in
            if error != nil{
                completion(error!, false)
                return
            }
            // check if user is logged in
            fetchUserWith(userId: (firUser?.user.uid)!, completion: { (user) in
                if user != nil && user?.firstName != ""{
                    // user is active go ahead and login
                    saveUserLocally(fbUser: user!)
                    completion(error, true)
                }else{
                    // need to register
                    let fUser = FBUser(_objectID: firUser!.user.uid, _pushID: "", _createdAt: Date(), _updatedAt: Date(), _firstName: "", _lastName: "", _phoneNumber: firUser!.user.phoneNumber!)
                    saveUserLocally(fbUser: fUser)
                    saveUserInBackground(fUser: fUser)
                    completion(error, false)
                }
            })
        }
    }
    
}


func saveUserInBackground(fUser: FBUser){
    let ref = firebase.child(kUser).child(fUser.objectID)
    ref.setValue(userDictonaryFrom(user: fUser))
}

//Mark: Save User defaults
func saveUserLocally(fbUser: FBUser){
    UserDefaults.standard.set(userDictonaryFrom(user: fbUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//Mark: Helper Functions
func fetchUserWith(userId: String, completion: @escaping (_ user: FBUser?)-> Void){
    firebase.child(kUser).queryOrdered(byChild: kObjectId).queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapshot) in
        if snapshot.exists(){
            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject as! NSDictionary
            let user = FBUser(_dictionary: userDictionary)
            completion(user)
        }else{
            completion(nil)
        }
    }
}

func userDictonaryFrom(user: FBUser) -> NSDictionary{
    
    let createdAt = dateFormatter().string(from: user.createdAt)
    let updatedAt = dateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectID, createdAt, updatedAt, user.companyName, user.pushID!, user.firstName, user.lastName, user.fullName, user.avatar, user.phoneNumber, user.phoneNumber, user.isAgent, user.coins, user.favortieProperties], forKeys: [kObjectId as NSCopying, kCreatedAt as NSCopying, kUpdatedAt as NSCopying, kCompany as NSCopying, kPUSHID as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kAVATAR as NSCopying, kPhone as NSCopying, kAddPhone as NSCopying, kISAGENT as NSCopying, kCOINS as NSCopying, kFAVORITEPROPERTIES as NSCopying])
    
}
func updateCurrentUser(withValues: [String: Any], withBlock: @escaping (_ success: Bool)->Void){
    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil{
        let currentUser = FBUser.currentUser()
        let userObject = userDictonaryFrom(user: currentUser!).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        let ref = firebase.child(kUser).child((currentUser?.objectID)!)
        ref.updateChildValues(withValues) { (error, ref) in
            if error != nil{
                withBlock(false)
                return
            }
            UserDefaults.standard.setValue(userObject, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            withBlock(true)
        }
    }
    
}


// MARK: OneSignal
func updateOneSignalID(){
    if FBUser.currentUser() != nil{
        if let pushID = UserDefaults.standard.string(forKey: "OneSignalId"){
            // set one signal id
            setOneSignalId(pushId: pushID)
        }else{
            // remove one signal id
            removeOneSignalId()
        }
    }
}

func setOneSignalId(pushId: String){
    updateCurrentUserOneSignalId(newID: pushId)
    
}
func removeOneSignalId(){
    updateCurrentUserOneSignalId(newID: "")
}
func updateCurrentUserOneSignalId(newID: String){
    updateCurrentUser(withValues: [kPUSHID : newID, kUpdatedAt: dateFormatter().string(from: Date())]) { (success) in
        print("WWWW::::::: One Signal was updated - \(success)")
    }
}
