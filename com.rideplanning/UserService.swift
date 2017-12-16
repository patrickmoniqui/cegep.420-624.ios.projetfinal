//
//  UserService.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class UserService {
    
    func Login(username: String, password: String, completionHandler: @escaping (AuthentificationViewModel?) -> Void) {
        
        let data = (username+":"+password).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let _headers: HTTPHeaders = [
            "Authorization": "Basic " + base64,
            "Accept": "application/json"]
        
        let url = URL(string: "http://riderqc-api.azurewebsites.net/login")
        
        Alamofire.request(url!, headers: _headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let _json = JSON(value)
                let token = AuthentificationViewModel(json: _json)
                self.SaveToken(authToken: token!)
                completionHandler(token!)
            case .failure(let error):
                completionHandler(nil)
            }
        }
    }
    
    func GetLoggedUser( completionHandler: @escaping ((UserViewModel) -> Void) ){
        var auth = self.GetToken()
        
        if let token = auth?.Token {
            let _headers: HTTPHeaders = [
                "Authorization": "Bearer " + token,
                "Accept": "application/json"]
            
            let url = URL(string: "http://riderqc-api.azurewebsites.net/user/bytoken")
            
            Alamofire.request(url!, headers: _headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let _json = JSON(value)
                    let userViewModel = UserViewModel(json: _json)
                    completionHandler(userViewModel!)
                case .failure(let error): break
                }
            }
        }
        else
        {
        }
    }

    
    
    func SaveToken(authToken: AuthentificationViewModel) {
        let context = self.getContext()
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Authentification", into: context)
        
        newEntity.setValue(authToken.Token, forKey: "token")
        newEntity.setValue(authToken.ExpiresOn, forKey: "expires")
        newEntity.setValue(authToken.IssuedOn, forKey: "issued")
        
        do {
            try context.save()
            print("token successfully added")
        }
        catch {
            print("Error while inserting token")
        }
    }
    
    func GetToken() -> AuthentificationViewModel?
    {
        let context = self.getContext()
        let request : NSFetchRequest<AuthentificationEntity> = AuthentificationEntity.fetchRequest()
            
        do {
            let _ : [AuthentificationEntity] = [AuthentificationEntity]()
            let tokens = try context.fetch(request)
    
            if(tokens.count == 1)
            {
                let token = AuthentificationViewModel()
                token.Token = tokens[0].token!
                token.IssuedOn = tokens[0].issued! as Date
                token.ExpiresOn = tokens[0].expires! as Date
                
                return token
            }
        }
        catch
        {
            print("Error fetching token")
            return nil
        }
        
        return nil
    }
    
    func DeleteToken()
    {
        let context = self.getContext()
            
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Authentification")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
                try context.save()
        }
        catch
        {
            print("Error deleting,, ")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "com.rideplanning")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Get Context
    func getContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = self.getContext()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
