//
//  MovieTableViewCell.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 19/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate(set) var movie: Movie!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(movie: Movie) {
        self.movie = movie

        titleLabel.text = movie.title
        
        Api.load(imageId: movie.posterPath, success: { (image) in
            self.posterImageView.image = image
        }) {
            log.error("Error during poster loading")
        }
    }
}
