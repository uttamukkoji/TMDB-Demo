//
//  SimilarMovieCollectionViewManager.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 27/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit
import RxSwift

class SimilarMovieCollectionViewManager: NSObject {
    // MARK: - Constants
    
    fileprivate enum UIConstants {
        static let margin: CGFloat = 10.0
        static let itemSizeRatio: CGFloat = ImageSize.posterRatio
    }
    
    // MARK: - Properties
    weak var collectionView: UICollectionView? {
        didSet {
            guard let collectionView = collectionView else { return }
            setup(collectionView)
        }
    }
    
    var movieClient: MovieClient = MovieClient()
    
    private var movieID: Int
    private var prefetchDataSource: CollectionViewPrefetching!
    private var dataSource: [Movie]
    private var hasMorePages: Bool = false
    private var nextPage : Int = 1
    private var itemSize: CGSize = .zero
    private let disposeBag: DisposeBag
    
    init(with movieID: Int) {
        self.movieID = movieID
        dataSource = []
        self.disposeBag = DisposeBag()
        super.init()
    }
    
    // MARK: - Setup
    private func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(MovieCollectionViewCell.self)
        self.itemSize = collectionView.frame.size.asCollectionViewItemSize(margin: UIConstants.margin, sizeRatio: UIConstants.itemSizeRatio)
        self.loadMoreMovie()
    }
    
    // MARK: -
    private func updateDataSource(with movieResult: MovieResult?) {
        if let result = movieResult {
            let index = dataSource.count
            self.hasMorePages = result.hasMorePages
            self.nextPage = result.nextPage
            guard let collectionView = collectionView else { return }
            switch result.currentPage {
            case 0:
                dataSource.removeAll()
                dataSource.append(contentsOf: result.results)
                collectionView.reloadData()
            default:
                dataSource.append(contentsOf: result.results)
                var indexPaths = [IndexPath]()
                for i in 0..<result.results.count {
                    indexPaths.append(IndexPath(row: index + i, section: 0))
                }
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: indexPaths)
                }, completion: nil)
            }
            self.setPrefetchingDataSource()
        }
    }
    
    func setPrefetchingDataSource() {
        prefetchDataSource = CollectionViewPrefetching(cellCount: dataSource.count, prefetchHandler: { [weak self] in
            self?.loadMoreMovie()
        })
        collectionView?.prefetchDataSource = prefetchDataSource
    }
    
    func loadMoreMovie() {
        movieClient.getMovies(page: nextPage, listType: MovieList.similar(movieId: self.movieID)) {[weak self] (result : Result<MovieResult?, APIError>) in
            switch result {
            case .success(let movieResult):
                self?.updateDataSource(with: movieResult)
            case .failure( _):
                break
            }
        }
    }
}
// MARK: -

extension SimilarMovieCollectionViewManager: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let movie = dataSource[indexPath.row]
        cell.populate(withPosterPath: movie.posterURL, andTitle: movie.title)
        return cell
    }
}

// MARK: -

extension SimilarMovieCollectionViewManager: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }
}

// MARK: -

extension SimilarMovieCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(all: UIConstants.margin)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIConstants.margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = {
            guard self.hasMorePages else { return 0.5 }
            return LoaderCollectionReusableView.height
        }()
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}

extension CGSize {
    
    // MARK: - CGSize helper
    
    fileprivate func asCollectionViewItemSize(margin: CGFloat, sizeRatio: CGFloat) -> CGSize {
        let newHeight = height - (2 * margin)
        let newWidth = newHeight * sizeRatio
        return CGSize(width: newWidth, height: newHeight)
    }
}
