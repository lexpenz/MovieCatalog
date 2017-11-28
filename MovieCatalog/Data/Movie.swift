//
//  Movie.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class Movie: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var posterPath = ""
    @objc dynamic var releaseDate = ""
    var genreIds = List<IntRealm>()
    @objc dynamic var overview = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["genres"]
    }
    
    var genres: [String] {
        get {
            if let realm = Realm.defaultRealm() {
                var genresList = [String]()
                for genre in genreIds {
                    if let name = realm.object(ofType: Genre.self, forPrimaryKey: genre.value)?.name {
                        genresList.append(name)
                    }
                }
                return genresList
            } else {
                return [""]
            }
        }
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        releaseDate <- map["release_date"]
        overview <- map["overview"]
        
        var genreIds: [Int]? = nil
        genreIds <- map["genre_ids"]
        genreIds?.forEach { option in
            let value = IntRealm()
            value.value = option
            self.genreIds.append(value)
        }
    }
}
