//
//  Log.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import Foundation
import XCGLogger

internal var log: XCGLogger = {
    let logger = XCGLogger.default
    logger.setup(level: .debug, showFunctionName: false, showThreadName: true, showLevel: false, showFileNames: false, showLineNumbers: false, writeToFile: nil, fileLevel: .debug)
    return logger
}()
