//
//  AuthentificationEntity+CoreDataProperties.swift
//  
//
//  Created by Patrick Moniqui on 17-11-23.
//
//

import Foundation
import CoreData


extension AuthentificationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthentificationEntity> {
        return NSFetchRequest<AuthentificationEntity>(entityName: "Authentification")
    }

    @NSManaged public var token: String?
    @NSManaged public var expires: NSDate?
    @NSManaged public var issued: NSDate?
    @NSManaged public var userid: Int64

}
