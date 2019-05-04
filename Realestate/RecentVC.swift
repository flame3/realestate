//
//  RecentVC.swift
//  Realestate
//
//  Created by nic on 25/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit


class RecentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var recentsCV: UICollectionView!
    
    var numberOfPropertiesTF: UITextField?
    var properties: [Property] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        recentsCV.collectionViewLayout.invalidateLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // load properties
        
        loadProperties(limitNumber: kRECENTPROPERTYLIMIT)
        
    }
    
    
    // MARK: Collection View Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentsCV.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! propertyCVCell
        ///   stopped here
        
        cell.delegate = self as! PropertyCollectionViewDeleagate
        cell.generateCell(property: properties[indexPath.row])
        
        
        
        return cell
    }
    
    
    
    
    // MARK: Collection view Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show property
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recentsCV.bounds.width, height: CGFloat(254))
    }
    
    // MARK: Log Properties
    
    func loadProperties(limitNumber: Int){
        Property.fetchRecentProperties(limitNumber: limitNumber) { (allProperties) in
            if allProperties.count != 0{
                self.properties = allProperties as! [Property]
                
                self.recentsCV.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: IBactions
    @IBAction func mixerBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Update", message: "set the number of properties", preferredStyle: .alert)
        
        alertController.addTextField { (numberOfProperties) in
            numberOfProperties.placeholder = "Number of Properties"
            numberOfProperties.borderStyle = .roundedRect
            numberOfProperties.keyboardType = .numberPad
            
         
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            })
            
            let updateAction = UIAlertAction(title: "Update", style: .default, handler: { (action) in
                if self.numberOfPropertiesTF?.text != "" && self.numberOfPropertiesTF?.text != "0"{
                    ProgressHUD.show("Updating")
                    self.loadProperties(limitNumber: Int(self.numberOfPropertiesTF!.text!)!)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(updateAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        func didClickStarBtn(property: Property){
            
            //check if we have a user
            if FBUser.currentUser() != nil{
                let user  = FBUser.currentUser()!
                
                // check if the property is in favorite
                
                if user.favortieProperties.contains(property.objectID!){
                    // remove from favorite list
                    let index = user.favortieProperties.index(of: property.objectID!)
                    user.favortieProperties.remove(at: index!)
                    
                    updateCurrentUser(withValues: [kFAVORITEPROPERTIES : user.favortieProperties ], withBlock:
                        { (success) in
                        if !success{
                            print("error removing favorites")
                        }else{
                            //self.collectionView.reloadData()
                            ProgressHUD.showSuccess("Removed from the list")
                        }
                    })
                    
                    
                    
                }else{
                    // add to favorite

                    user.favortieProperties.append(property.objectID!)
                    
                    updateCurrentUser(withValues: [kFAVORITEPROPERTIES : user.favortieProperties ], withBlock:
                        { (success) in
                            if !success{
                                print("error adding property")
                            }else{
                                //self.collectionView.reloadData()
                                ProgressHUD.showSuccess("Added to the list")
                            }
                    })
                }
                
            }else{
                // show login/ register screen
                
            }
        }
    }
    
    
    
}
