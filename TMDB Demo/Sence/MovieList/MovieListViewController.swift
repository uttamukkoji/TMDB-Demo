//
//  MovieListViewController.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, MovieDetailsTransitionable {
   
    var selectedCell: MovieCollectionViewCell?

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lazy properties
    private lazy var movieCollectionViewManager = {
        return MovieCollectionViewManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming Movie"
        movieCollectionViewManager.delegate = self
        movieCollectionViewManager.collectionView = collectionView
        self.navigationController?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationView = segue.destination as? MovieDetailsViewController, let movie = sender as? Movie {
            destinationView.movieModel = movie
        }
    }
}

extension MovieListViewController: MovieCollectionViewManagerDelegate {
    func showMovieDetails(for cell: MovieCollectionViewCell, model: Movie) {
        self.selectedCell = cell
        performSegue(withIdentifier: "ShowMovieDetail", sender: model)
    }
}

extension MovieListViewController: UINavigationControllerDelegate {
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch (operation, fromVC, toVC) {
        case (.push, _, toVC) where toVC is MovieDetailsViewController:
            guard let fromVC = fromVC as? (UIViewController & MovieDetailsTransitionable) else { return nil }
            return ToFilmDetailsTransitionAnimator(from: fromVC, destinationView: toVC.view)
        default: return nil
        }
    }
}


