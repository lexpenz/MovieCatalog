//
//  Genre.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 23/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class Genre: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
