//
//  TrajetService.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-12-18.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TrajetService {
    func GetTrajetList( completionHandler: @escaping ((Array<TrajetViewModel>) -> Void) ){
        var items = [TrajetViewModel]()
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/trajet/list")
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                for item in _json.arrayValue {
                    let _item = TrajetViewModel(json: item)
                    items.append(_item!)
                }
                completionHandler(items)
            case .failure(let error):
                print(error)
            }
        }
    }
}
