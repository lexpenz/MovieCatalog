//
//  MovieDetailsViewController.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import RealmSwift
import Reachability

class MovieDetailsViewController: UIViewController, ConnectionErrorPresentable {
    fileprivate var movieDetailsView: MovieDetailsView {
        return view as! MovieDetailsView
    }
    
    var movie: Movie!
    
    fileprivate let jsonProcessor = JsonProcessor(realm: Realm.defaultRealm()!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = MovieDetailsView(movie: movie)
        title = movie.title
        
        movieDetailsView.watchTrailerButton.addTarget(self, action: #selector(self.watchTrailerButtonTapped), for: .touchUpInside)
        
        Api.load(imageId: movie.posterPath, success: { (image) in
            self.movieDetailsView.posterImageView.image = image
        }) {
            log.error("Error during loading of image")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: Notification.Name.reachabilityChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        movieDetailsView.sizeDependentSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        movieDetailsView.sizeDependentSetup(size: size)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if !ReachabilityManager.shared.isConnected {
            showConnectionErrorAlert()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
    }
}

// MARK:- Actions
extension MovieDetailsViewController {
    @objc func watchTrailerButtonTapped() {
        playVideo()
    }
}

// MARK:- Video player
extension MovieDetailsViewController {
    func playVideo() {
        if ReachabilityManager.shared.isConnected {
            Api.loadTrailers(movieId: movie.id, success: { (json) in
                if let id = self.jsonProcessor.processTrailerId(trailersJson: json) {
                    let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: id)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayerPlaybackDidFinish), name: .MPMoviePlayerPlaybackDidFinish, object: videoPlayerViewController.moviePlayer)
                    self.presentMoviePlayerViewControllerAnimated(videoPlayerViewController as? MPMoviePlayerViewController ?? MPMoviePlayerViewController())
                } else {
                    log.error("No video id found in json: \(json)")
                }
            }) { (error) in
                log.error("Error during trailer list loading")
            }
        } else {
            showConnectionErrorAlert()
        }
    }
    
    @objc func moviePlayerPlaybackDidFinish(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .MPMoviePlayerPlaybackDidFinish, object: notification.object)
    }
}
