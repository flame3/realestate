//
//  Downloader.swift
//  Realestate
//
//  Created by nic on 5/5/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import Foundation
import Firebase

let storage = Storage.storage()

func downloadImages(urls: String, withBlock: @escaping (_ image: [UIImage?]) ->Void){
    let linkArray = seperateImageLinks(allLinks: urls)
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0
    
    for link in linkArray{
        
        let url = NSURL(string: link)
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQue")
        downloadQueue.async {
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil{
                
                imageArray.append(UIImage(data: data! as Data)!)
                
                
                if downloadCounter == imageArray.count{
                    
                    DispatchQueue.main.async {
                        withBlock(imageArray)
                    }
                }
            }else{
                print("couldnt download image ")
                withBlock(imageArray)
            }
        }
    }
    
}

func uploadImages(images: [UIImage], userId: String, referenceNum: String, withBlock: @escaping (_ imageLink: String?)-> Void){
    
    convertImagesToData(images: images) { (pictures) in
        var uploadCounter = 0
        var nameSuffix = 0
        var linkString = ""
        
        for picture in pictures{
            let fileName = "PropertyImages/" + userId + "/" + referenceNum + "/image" + "\(nameSuffix)" + ".jpg"
            nameSuffix += 1
            
            let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
            
            var taskBar: StorageUploadTask!
            
            
            
              storageRef.downloadURL(completion: { (url, error) in
                
                if error != nil {
                    
                    print("generate url \(error.debugDescription)")
                    return
                }
                
                let link = url?.absoluteString
                linkString = linkString + link! + ","
                
                if uploadCounter == picture.count {
                    taskBar.removeAllObservers()
                    withBlock(linkString)
                }
                
            })
            
           
//            taskBar = storageRef.putData(picture, metadata: nil, completion: { (metaData, error) in
//                uploadCounter += 1
//                if error != nil{
//                    print("error uploading picture \(error?.localizedDescription)")
//                    return
//                }else{
//                    let link = metaData.downloadURl()
//
//
//                    linkString = linkString + link.absoluteString + ","
//                    if uploadCounter == pictures.count{
//                        taskBar.removeAllObservers()
//                        withBlock(linkString)
//
//                    }
//                }
//            })
        }
    }
    
}


// MARK: Helpers

func convertImagesToData(images: [UIImage], withBlock: @escaping (_ datas: [Data])-> Void ){
    var dataArray: [Data] = []
    for image in images{
        let imageData = image.jpegData(compressionQuality: 0.5)
        dataArray.append(imageData!)
    }
    
    withBlock(dataArray)
}

func seperateImageLinks(allLinks: String)-> [String]{
    var linkArray = allLinks.components(separatedBy: ",")
    linkArray.removeLast()
    
    return linkArray
}
