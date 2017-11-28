//
//  ResponceProcessor.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 27/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import RealmSwift

class JsonProcessor {
    fileprivate let realm: Realm!
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func process(movieResults: [String: Any]) {
        guard let realm = realm else { return }
        do {
            if let results = movieResults["results"] as? [Any] {
                try realm.write {
                    realm.delete(realm.objects(Movie.self))
                }
                
                for result in results {
                    let movie = Movie(JSON: result as! [String: Any])
                    try realm.write {
                        realm.add(movie!)
                    }
                }
            }
        }
        catch let error as NSError {
            log.error("Error during processing Movies JSON: \(error)")
        }
    }
    
    func process(genresResults: [String: Any]) {
        guard let realm = realm else { return }
        
        do {
            if let results = genresResults["genres"] as? [Any] {
                try realm.write {
                    realm.delete(realm.objects(Genre.self))
                }
                
                for result in results {
                    let genre = Genre(JSON: result as! [String: Any])
                    try realm.write {
                        realm.add(genre!)
                    }
                }
            }
        }
        catch let error as NSError {
            log.error("Error during processing Genres JSON: \(error)")
        }
    }
    
    func processTrailerId(trailersJson: [String: Any]) -> String? {
        let results = trailersJson["results"] as? [Any]
        let firstVideoJson = results?.first as? [String: Any]
        let keyString = firstVideoJson?["key"] as? String
        
        return keyString
    }
}
