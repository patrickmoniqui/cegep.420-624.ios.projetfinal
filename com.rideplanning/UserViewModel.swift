//
//  UserViewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-28.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserViewModel {
    
    var userId: Int
    var username: String
    var region: String?
    var ville: String?
    var birth: Date?
    var description: String?
    
    init() {
        self.userId = -1
        self.username = ""
        self.region = ""
        self.ville = ""
        self.birth = Date()
        self.description = ""
    }
    
    init?(json: JSON) {
        
        self.userId = json["UserID"].intValue
        self.username = json["Username"].stringValue
        self.region = json["Region"].stringValue
        self.ville = json["Ville"].stringValue
        self.birth = DateHelpers.stringToDate(dateString: json["DateOfBirth"].stringValue)
        self.description = json["Description"].stringValue
    }
    
}
