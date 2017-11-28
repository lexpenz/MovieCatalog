//
//  MovieCatalogTests.swift
//  MovieCatalogTests
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MovieCatalog

class JsonProcessorTests: XCTestCase {
    var jsonProcessor: JsonProcessor!//(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MovieCatalogTestsInMemoryRealm")))
    var realm: Realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MovieCatalogTestsInMemoryRealm"))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        jsonProcessor = JsonProcessor(realm: realm)
        clearRealm()
    }
    
    func clearRealm() {
        try! self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoviesProcessing() {
        // arrange
        let sampleJsonFileName = "test_Movies"
        guard let pathString = Bundle(for: type(of: self)).path(forResource: String(sampleJsonFileName), ofType: "json") else {
            XCTFail("Test json file was not found")
            return
        }
       
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: pathString)) else {
            XCTFail("Unable to read data")
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] else {
            XCTFail("Unable to convert data to json")
            return
        }

        // act
        jsonProcessor.process(movieResults: json)
        
        // assert
        XCTAssertTrue(realm.objects(Movie.self).count > 0, "Expected > 0")
        XCTAssertEqual(realm.objects(Movie.self).first!.title, "It")
    }
    
    func testGenresProcessing() {
        // arrange
        let sampleJsonFileName = "test_Genres"
        guard let pathString = Bundle(for: type(of: self)).path(forResource: String(sampleJsonFileName), ofType: "json") else {
            XCTFail("Test json file was not found")
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: pathString)) else {
            XCTFail("Unable to read data")
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] else {
            XCTFail("Unable to convert data to json")
            return
        }
        
        // act
        jsonProcessor.process(genresResults: json)
        
        // assert
        XCTAssertTrue(realm.objects(Genre.self).count > 0)
        XCTAssertEqual(realm.objects(Genre.self).first!.name, "Action")
    }
}
