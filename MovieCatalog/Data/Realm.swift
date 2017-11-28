//
//  Realm.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

extension Realm {
    /**
     Initializes a default Realm instance
     */
    class func defaultRealm() -> Realm? {
        var realm: Realm?
        
        do {
            realm = try Realm()
        } catch let error as NSError {
            realm = nil
            log.error("Failed to initialize a default Realm instance with error: \(error.description)")
        }
        
        return realm
    }
}
