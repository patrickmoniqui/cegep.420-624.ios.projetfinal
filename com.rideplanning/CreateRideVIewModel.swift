//
//  CreateRideVIewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-12-17.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreateRideViewModel {
    var Title: String
    var Description: String
    var TrajetId: Int?
    var LevelId: Int
    var DateDepart: Date?
    var DateFin: Date?
    
    init()
    {
        Title = ""
        Description = ""
        TrajetId = nil
        LevelId = -1
        DateDepart = nil
        DateFin = nil
    }
    
    init?(json: JSON) {
        
        self.Title = json["Title"].stringValue
        self.Description = json["Description"].stringValue
        self.TrajetId = json["TrajetId"].intValue
        self.LevelId = json["LevelId"].intValue
        self.DateDepart = DateHelpers.stringToDate(dateString: json["DateDepart"].stringValue)!
        self.DateFin = DateHelpers.stringToDate(dateString: json["DateFin"].stringValue)!
    }

    func toJson() -> String
    {
        var json: String = "{"
        
        json.append("\"Title\": \"" + String(self.Title) + "\",")
        json.append("\"Description\": \"" + String(self.Description) + "\",")
        json.append("\"LevelId\": " + String(self.LevelId) + ",")
        
        //optinal
        if let trajetid = self.TrajetId {
            json.append("\"TrajetId\": " + String(trajetid) + ",")
        }
        
        json.append("\"DateDepart\": \"" + DateHelpers.dateToApiServiceString(date: self.DateDepart!) + "\",")
        json.append("\"DateFin\": \"" + DateHelpers.dateToApiServiceString(date: self.DateFin!) + "\"")
        
        json.append("}")
        
        return json
    }
}
