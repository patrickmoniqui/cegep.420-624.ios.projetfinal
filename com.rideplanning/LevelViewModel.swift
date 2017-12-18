//
//  LevelViewModel.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-12-17.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON

class LevelViewModel {
    var levelId: Int
    var name: String
    
    init() {
        self.levelId = -1
        self.name = ""
    }
    
    init?(json: JSON) {
        
        self.levelId = json["LevelId"].intValue
        self.name = json["Name"].stringValue
    }

}
