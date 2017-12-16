//
//  RideService.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-22.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RideService {
    
    func GetRideList( completionHandler: @escaping ((Array<RideViewModel>) -> Void) ){
        var rides = [RideViewModel]()
        
         let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/list")
            Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                for ride in _json.arrayValue {
                    let _ride = RideViewModel(json: ride)
                    rides.append(_ride!)
                }
                completionHandler(rides)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetMyRideList(username: String, completionHandler: @escaping ((Array<RideViewModel>) -> Void) ){
        var rides = [RideViewModel]()
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/myrides?username=" + username)
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                for ride in _json.arrayValue {
                    let _ride = RideViewModel(json: ride)
                    rides.append(_ride!)
                }
                completionHandler(rides)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetRideById(rideId: Int,  completionHandler: @escaping ((SingleRideViewModel?) -> Void) ){
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/" + String(rideId))
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                let _ride = SingleRideViewModel(json: _json)
                completionHandler(_ride ?? nil)
            case .failure(let error):
                completionHandler(nil)
                print(error)
            }
        }
    }
}
