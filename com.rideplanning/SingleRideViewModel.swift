//
//  SingleRideViewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class SingleRideViewModel
{
    var RideId: Int
    var Title: String
    var Description: String
    
    var DateDepart: Date
    var DateFin: Date
    
    var Trajet: TrajetViewModel
    
    init()
    {
        RideId = -1
        Title = ""
        Description = ""
        DateDepart = Date()
        DateFin = Date()
        Trajet = TrajetViewModel()
    }
    
    init?(json: JSON) {
        
        self.RideId = json["RideId"].intValue
        self.Title = json["Title"].stringValue
        self.Description = json["Description"].stringValue
        self.DateDepart = DateHelpers.stringToDate(dateString: json["DateDepart"].stringValue)!
        self.DateFin = DateHelpers.stringToDate(dateString: json["DateFin"].stringValue)!
        let _trajet = json["Trajet"]
        self.Trajet = TrajetViewModel(json: _trajet)!
    }
}
