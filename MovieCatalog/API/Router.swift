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

public typealias Coordinates = (latitude: Double, longitude: Double)

public enum Router: URLRequestConvertible {
    case popular
    case genres
    case trailer(movieId: Int)
    case poster(id: String)
    
    var baseUrl: String {
        switch self {
        case .popular, .trailer:
            return "http://api.themoviedb.org/3/movie"//        default:
        case .genres:
            return "http://api.themoviedb.org/3/genre/movie/list"
        case .poster:
            return "http://image.tmdb.org/t/p/w342"
        }
    }
    
    private var key: String { get { return "api_key=\(AppDelegate.shared.key)" } }
    
    var method: HTTPMethod {
        switch self {
        case .popular, .poster, .trailer, .genres:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .popular:
            return "/popular"
        case .genres:
            return ""
        case .trailer(let id):
            return "/\(id)/videos"
        case .poster(let id):
            return "/\(id)"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters = [String: Any]()
        
        let url = try (baseUrl+path+"?"+key).asURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

