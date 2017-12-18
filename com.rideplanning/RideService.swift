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
    
    func CreateRude(ride: CreateRideViewModel,  completionHandler: @escaping ((Bool) -> Void) ){
        let userService = UserService()
        let auth = userService.GetToken()
        let token = auth?.Token
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/ride")

        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token!, forHTTPHeaderField: "Authorization")
        let data = (ride.toJson().data(using: .utf8))! as Data
        request.httpBody = data
        
        print(request)
        
        print("body: " + ride.toJson())
        
        Alamofire.request(request).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let id):
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    func EditRide(rideId: Int, ride: CreateRideViewModel,  completionHandler: @escaping ((Bool) -> Void) ){
        let userService = UserService()
        let auth = userService.GetToken()
        let token = auth?.Token
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/" + String(rideId))
        
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token!, forHTTPHeaderField: "Authorization")
        let data = (ride.toJson().data(using: .utf8))! as Data
        request.httpBody = data
        
        print(request)
        
        print("body: " + ride.toJson())
        
        Alamofire.request(request).responseString { (response) in
            print(response)
            switch response.result {
            case .success(let _):
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }


    
    func GetRideList( completionHandler: @escaping ((Array<RideListViewModel>) -> Void) ){
        var rides = [RideListViewModel]()
        
         let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/list")
            Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                for ride in _json.arrayValue {
                    let _ride = RideListViewModel(json: ride)
                    rides.append(_ride!)
                }
                completionHandler(rides)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetMyRideList(username: String, completionHandler: @escaping ((Array<RideListViewModel>) -> Void) ){
        var rides = [RideListViewModel]()
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/myrides?username=" + username)
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                for ride in _json.arrayValue {
                    let _ride = RideListViewModel(json: ride)
                    rides.append(_ride!)
                }
                completionHandler(rides)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetRideById(rideId: Int,  completionHandler: @escaping ((RideViewModel?) -> Void) ){
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/ride/" + String(rideId))
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                let _ride = RideViewModel(json: _json)
                completionHandler(_ride ?? nil)
            case .failure(let error):
                completionHandler(nil)
                print(error)
            }
        }
    }
}
