//
//  MovieDetailsView.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 27/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit
import SnapKit

class MovieDetailsView: UIView {
    private struct Consts {
        static let viewMultiplier = 0.4
    }
    
    let scrollView = UIScrollView()
    let topStackView = UIStackView()
    let posterImageView = UIImageView()
    
    let innerStackView = UIStackView()
    let titleLabel = TitleLabel()
    let watchTrailerButton = UIButton(type: .custom)
    
    let bottomStackView = UIStackView()
    let genresTitleLabel = SubtitleLabel()
    let genresLabel = UILabel()
    let dateTitleLabel = SubtitleLabel()
    let dateLabel = UILabel()
    let overviewTitleLabel = SubtitleLabel()
    let overviewLabel = UILabel()
    
    fileprivate var movie: Movie!
    
    init(movie: Movie) {
        self.movie = movie
        
        super.init(frame: CGRect.zero)
        
        initialize()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
        setupConstraints()
        sizeDependentSetup()
    }
}

extension MovieDetailsView {
    func initialize() {
        addSubview(scrollView)
        
        scrollView.addSubview(topStackView)
        scrollView.addSubview(bottomStackView)
        
        topStackView.addArrangedSubview(posterImageView)
        topStackView.addArrangedSubview(innerStackView)
        
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(watchTrailerButton)
        
        bottomStackView.addArrangedSubview(genresTitleLabel)
        bottomStackView.addArrangedSubview(genresLabel)
        bottomStackView.addArrangedSubview(dateTitleLabel)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(overviewTitleLabel)
        bottomStackView.addArrangedSubview(overviewLabel)
        
        backgroundColor = .white
        
        topStackView.axis = .vertical
        topStackView.spacing = Constants.marginSmall
        
        innerStackView.axis = .vertical
        innerStackView.spacing = Constants.marginSmall
        innerStackView.layoutMargins = UIEdgeInsets(top: 0, left: Constants.marginDefault, bottom: 0, right: Constants.marginDefault)
        innerStackView.isLayoutMarginsRelativeArrangement = true
        
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .fill
        bottomStackView.spacing = Constants.marginSmall
        bottomStackView.layoutMargins = UIEdgeInsets(top: 0, left: Constants.marginDefault, bottom: 0, right: Constants.marginDefault)
        bottomStackView.isLayoutMarginsRelativeArrangement = true
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel.text = movie.title
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        
        watchTrailerButton.setTitle(NSLocalizedString("Watch Trailer", comment: ""), for: .normal)
        watchTrailerButton.setTitleColor(.black, for: .normal)
        watchTrailerButton.backgroundColor = .lightGray
        
        genresTitleLabel.text = NSLocalizedString("Genres", comment: "")
        
        var genres = ""
        for genre in movie.genres {
            if genres.count > 0 {
                genres.append(", ")
            }
            genres.append(genre)
        }
        genresLabel.text = genres
        genresLabel.numberOfLines = 0
        genresLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        
        dateTitleLabel.text = NSLocalizedString("Date", comment: "")
        dateLabel.text = movie.releaseDate
        
        overviewTitleLabel.text = NSLocalizedString("Overview", comment: "")
        overviewLabel.text = movie.overview
        overviewLabel.numberOfLines = 0
        overviewLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        topStackView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.right.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.width.equalTo(self)
        }
        
        bottomStackView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.right.equalTo(scrollView)
            make.top.equalTo(topStackView.snp.bottom).offset(Constants.marginSmall)
            make.bottom.equalTo(scrollView)
            make.width.equalTo(self)
        }
        
        innerStackView.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(self).multipliedBy(Consts.viewMultiplier)
        }
    }
    
    func sizeDependentSetup(size: CGSize? = nil) {
        var checkSize: CGSize
        if let unwrappedSize = size {
            checkSize = unwrappedSize
        } else {
            checkSize = frame.size
        }
        if checkSize.height < checkSize.width {
            topStackView.axis = .horizontal
        } else {
            topStackView.axis = .vertical
        }
    }
}
