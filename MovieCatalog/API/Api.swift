//
//  Api.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import ObjectMapper

class Api {
    static func loadPopularMovies(success: @escaping (_ json: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        Alamofire.request(Router.popular)
            .responseJSON { response in
                if let error = response.error {
                    log.error("Error loading movies: \(error)")
                    failure(error)
                } else {
                    if let json = response.result.value as? [String: Any] {
                        success(json)
                        
                    }
                }
        }
    }
    
    static func loadTrailers(movieId: Int, success: @escaping (_ json: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        Alamofire.request(Router.trailer(movieId: movieId))
            .responseJSON { response in
                if let error = response.error {
                    log.error("Error loading trailers: \(error)")
                    failure(error)
                } else {
                    if let json = response.result.value as? [String: Any] {
                        success(json)
                    }
                }
        }
    }
    
    static func loadGenres(success: @escaping (_ json: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        Alamofire.request(Router.genres)
            .responseJSON { response in
                if let error = response.error {
                    log.error("Error loading genres: \(error)")
                    failure(error)
                } else {
                    if let json = response.result.value as? [String: Any] {
                        success(json)
                        
                    }
                }
        }
    }
    
    
    
    // MARK:- Images
    static fileprivate let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    static func load(imageId: String, success: @escaping (UIImage) -> Void, failure: @escaping () -> Void) {
        Api.imageDownloader.download(Router.poster(id: imageId)) { response in
            if let image = response.result.value {
                success(image)
            } else {
                failure()
            }
        }
    }
}



