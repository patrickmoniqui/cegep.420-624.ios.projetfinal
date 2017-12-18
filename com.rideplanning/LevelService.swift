//
//  LevelService.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-12-17.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LevelService {
    func GetLevelList( completionHandler: @escaping ((Array<LevelViewModel>) -> Void) ){
        var levels = [LevelViewModel]()
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/level/list")
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                for level in _json.arrayValue {
                    let _level = LevelViewModel(json: level)
                    levels.append(_level!)
                }
                completionHandler(levels)
            case .failure(let error):
                print(error)
            }
        }
    }
}
