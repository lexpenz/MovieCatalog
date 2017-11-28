//
//  SubtitleLabel.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 28/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit

class SubtitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
}

fileprivate extension SubtitleLabel {
    func initialize() {
        font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
}
