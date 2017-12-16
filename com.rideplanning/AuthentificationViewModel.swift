//
//  AuthentificationViewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthentificationViewModel {
    var Token: String
    var ExpiresOn: Date
    var IssuedOn: Date
    
    init()
    {
        self.Token = ""
        self.ExpiresOn = Date()
        self.IssuedOn = Date()
    }
    
    init?(json: JSON) {
        
        self.Token = json["Token"].stringValue
        self.IssuedOn = DateHelpers.stringToDate(dateString: json["IssueDate"].stringValue)!
        self.ExpiresOn = DateHelpers.stringToDate(dateString: json["ExpirationDate"].stringValue)!
    }
}
