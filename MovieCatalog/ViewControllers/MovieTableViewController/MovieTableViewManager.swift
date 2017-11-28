//
//  MovieTableViewManager.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 20/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit
import RealmSwift

class MovieTableViewManager: NSObject {
    var openMovieDetailsHandler: ((Movie)->())?
    
    fileprivate let jsonProcessor = JsonProcessor(realm: Realm.defaultRealm()!)
    
    override init() {
        super.init()
        
        guard let realm = Realm.defaultRealm() else { return }
        
        try! realm.write {
            realm.deleteAll()
        }
        
        if ReachabilityManager.shared.isConnected {
            Api.loadPopularMovies(success: { [unowned self] (json) in
                self.jsonProcessor.process(movieResults: json)
                self.updateData()
                self.filterMovie(text: "")
            }) { (error) in
                log.error("Error during loading movies: \(error)")
            }
            
            Api.loadGenres(success: { [unowned self] (json) in
                self.jsonProcessor.process(genresResults: json)
            }) { (error) in
                log.error("Error during loading genres: \(error)")
            }
        }
    }
    
    weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.tableFooterView = nil
            
            self.tableView.register(
                UINib(nibName: "MovieTableViewCell", bundle: nil),
                forCellReuseIdentifier: MovieTableViewCell.identifier
            )
        }
    }
    

    fileprivate var movieList: Results<Movie>?
    
    fileprivate func updateData() {
        guard let realm = Realm.defaultRealm() else { return }
        
        movieList = realm.objects(Movie.self)
    }
    
    fileprivate var filteredMovieList: Results<Movie>?
    
    func filterMovie(text: String) {
        if text == "" {
            filteredMovieList = movieList
        } else {
            filteredMovieList = movieList?.filter("title CONTAINS[cd] %@", text)
        }
        tableView.reloadData()
    }
}

extension MovieTableViewManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovieList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(movie: filteredMovieList![indexPath.row])

        return cell
    }
    
}

extension MovieTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
            openMovieDetailsHandler?(cell.movie)
        }
    }
}
