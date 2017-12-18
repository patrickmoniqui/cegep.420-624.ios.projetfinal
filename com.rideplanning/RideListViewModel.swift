//
//  RideListViewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-12-17.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class RideListViewModel {
    var RideId: Int
    var Title: String
    var Description: String
    
    var DateDepart: Date
    var DateDebutString: String {
        get { return DateHelpers.dateToString(date: self.DateDepart) }
    }
    
    var DateFin: Date
    var DateFinString: String {
        get { return DateHelpers.dateToString(date: self.DateFin) }
    }
    
    init()
    {
        RideId = -1
        Title = ""
        Description = ""
        DateDepart = Date()
        DateFin = Date()
    }
    
    init?(json: JSON) {
        
        self.RideId = json["RideId"].intValue
        self.Title = json["Title"].stringValue
        self.Description = json["Description"].stringValue
        self.DateDepart = DateHelpers.stringToDate(dateString: json["DateDepart"].stringValue)!
        self.DateFin = DateHelpers.stringToDate(dateString: json["DateFin"].stringValue)!
    }

}
