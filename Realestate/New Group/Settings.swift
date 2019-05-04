//
//  Settings.swift
//  Realestate
//
//  Created by nic on 19/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import Foundation

private let dateFormat = "yyyyMMddHHmmss"
func dateFormatter() -> DateFormatter{
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}
