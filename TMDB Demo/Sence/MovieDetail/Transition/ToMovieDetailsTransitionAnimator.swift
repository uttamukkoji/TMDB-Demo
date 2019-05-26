//
//  ToMovieDetailsTransitionAnimator.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit


protocol MovieDetailsTransitionable: class {
    
    // MARK: - FilmDetailsTransitionable protocol
    
    var selectedCell: MovieCollectionViewCell? { get }
}

// MARK: -

final class ToFilmDetailsTransitionAnimator: NSObject {
    
    // MARK: - Properties
    
    fileprivate var selectedCell: MovieCollectionViewCell
    fileprivate var sourceView: UIView
    fileprivate var destinationView: UIView
    
    // MARK: - Initializer
    
    init?(from movieDetailsTransitionable: UIViewController & MovieDetailsTransitionable, destinationView: UIView) {
        guard let cell = movieDetailsTransitionable.selectedCell else { return nil }
        self.selectedCell = cell
        self.sourceView = movieDetailsTransitionable.view
        self.destinationView = destinationView
        super.init()
    }
}

// MARK: -

extension ToFilmDetailsTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let posterImageView: UIImageView = {
            let view = UIImageView(frame: selectedCell.convert(selectedCell.bounds, to: sourceView))
            view.backgroundColor = UIColor.groupTableViewBackground
            view.image = selectedCell.moviePosterImageView.image
            return view
        }()
        
        let blurView: UIVisualEffectView = {
            let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            view.frame = posterImageView.bounds
            view.alpha = 0.0
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }()
        
        posterImageView.addSubview(blurView)
        transitionContext.containerView.addSubview(sourceView)
        transitionContext.containerView.addSubview(destinationView)
        transitionContext.containerView.addSubview(posterImageView)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
            posterImageView.frame = transitionContext.containerView.bounds
            blurView.alpha = 1.0
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        UIView.animate(withDuration: 0.1, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            posterImageView.alpha = 0.0
        }, completion: { (_) in
            posterImageView.removeFromSuperview()
        })
    }
}
