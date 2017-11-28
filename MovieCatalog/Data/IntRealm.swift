//
//  IntRealm.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 23/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class IntRealm: Object {
    @objc dynamic var value = 0
}
