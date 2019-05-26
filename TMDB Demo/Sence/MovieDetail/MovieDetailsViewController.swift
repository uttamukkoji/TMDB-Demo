//
//  MovieDetailsViewController.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movieModel: Movie?
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backdropImageViewHeight: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieSubDetailsView: UIView!
    @IBOutlet weak var movieRatingImageView: UIImageView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var similarView: UIView!
    @IBOutlet weak var similarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var similarLabel: UILabel!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    
    private lazy var movieCollectionViewManager = {
        return SimilarMovieCollectionViewManager(with: self.movieModel!.id)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        movieCollectionViewManager.delegate = self
        movieCollectionViewManager.collectionView = similarCollectionView
        // Do any additional setup after loading the view.
    }
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = self.view.bounds.width / ImageSize.backdropRatio
        self.scrollView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func setupUI() {
            
        self.movieSubDetailsView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { self.movieSubDetailsView.alpha = 1.0 }
        self.movieRatingLabel.text = "\(movieModel?.voteAverage ?? 0)/10"
        self.blurredImageView.contentMode = .scaleAspectFill
        if let backdropURL = movieModel?.backdropURL {
            if let posterURL = movieModel?.posterURL {
                blurredImageView.setImage(fromTMDbPath: posterURL, animatedOnce: true, withPlaceholder: nil)
            }
            self.backdropImageView.contentMode = .scaleAspectFill
            self.backdropImageView.setImage(fromTMDbPath: backdropURL, animatedOnce: true, withPlaceholder: nil)
            self.backdropImageView.backgroundColor = UIColor.clear
        } else if let posterURL = movieModel?.posterURL {
            blurredImageView.setImage(fromTMDbPath: posterURL, animatedOnce: true, withPlaceholder: nil)
            self.backdropImageView.contentMode = .scaleAspectFill
            self.backdropImageView.setImage(fromTMDbPath: posterURL, animatedOnce: true, withPlaceholder: nil)
            self.backdropImageView.backgroundColor = UIColor.clear
        } else {
            self.blurredImageView.image = nil
            self.backdropImageView.contentMode = .scaleAspectFit
            self.backdropImageView.image = #imageLiteral(resourceName: "Logo_Icon")
            self.backdropImageView.backgroundColor = UIColor.groupTableViewBackground
        }
        self.movieTitleLabel.text = movieModel?.title.uppercased()
        self.movieOverviewLabel.text = movieModel?.overview
        self.similarViewHeight.constant = 15.0 + self.similarLabel.font.lineHeight + 200.0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
