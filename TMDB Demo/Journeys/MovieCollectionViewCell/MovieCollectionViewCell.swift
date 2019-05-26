//
//  MovieCollectionViewCell.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    // MARK: - UICollectionViewCell life cycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        self.movieTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
    }
    
    // MARK: -
    
    func populate(withPosterPath posterURL: URL?, andTitle title: String) {
        self.movieTitleLabel.text = title
        self.moviePosterImageView.image = nil
        if let posterURL =  posterURL {
            self.moviePosterImageView.setImage(fromTMDbPath: posterURL, animatedOnce: true, withPlaceholder: nil)
        }
    }
}

