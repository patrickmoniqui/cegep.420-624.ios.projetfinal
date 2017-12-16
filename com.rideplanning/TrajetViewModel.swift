//
//  TrajetViewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrajetViewModel {
    
    var trajetId: Int
    var TrajetTitle: String
    var TrajetDesc: String?
    var GpsPoints: [String]
    
    init(){
        self.trajetId = -1
        self.TrajetTitle = ""
        self.TrajetDesc = nil
        self.GpsPoints = [String]()
    }
    
    init?(json: JSON) {
        
        self.trajetId = json["TrajetId"].intValue
        self.TrajetTitle = json["Title"].stringValue
        
        self.GpsPoints = [String]()
        
        for gps in json["GpsPoints"].arrayValue
        {
            self.GpsPoints.append(gps.stringValue)
        }
    }
}
