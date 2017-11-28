//
//  ReachabilityManager.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 20/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager {
    static var shared = ReachabilityManager()
    
    var isConnected: Bool {
        return reachability.isReachable()
    }
    
    private let reachability = Reachability(hostName: "api.themoviedb.org")!
    
    private init() {

        reachability.startNotifier()
    }
}

private extension ReachabilityManager {
}
