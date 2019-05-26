//
//  MovieCollectionViewManager.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit
import RxSwift

protocol MovieCollectionViewManagerDelegate: NSObjectProtocol {
    func showMovieDetails(for cell: MovieCollectionViewCell, model: Movie)
}

class MovieCollectionViewManager: NSObject {
    // MARK: - Constants
    
    fileprivate enum UIConstants {
        static let margin: CGFloat = 10.0
        static let itemSizeRatio: CGFloat = ImageSize.posterRatio
    }
    
    // MARK: - Properties
    weak open var delegate: MovieCollectionViewManagerDelegate?
    weak var collectionView: UICollectionView? {
        didSet {
            guard let collectionView = collectionView else { return }
            setup(collectionView)
        }
    }
    
    var movieClient: MovieClient = MovieClient()

    private var prefetchDataSource: CollectionViewPrefetching!
    private var dataSource: [Movie]
    private var hasMorePages: Bool = false
    private var nextPage : Int = 1
    private var itemSize: CGSize = .zero
    private let disposeBag: DisposeBag

    override init() {
        dataSource = []
        self.disposeBag = DisposeBag()
        super.init()
    }
    
    // MARK: - Setup
    private func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(MovieCollectionViewCell.self)
        collectionView.registerSupplementaryView(LoaderCollectionReusableView.self, ofKind: UICollectionView.elementKindSectionFooter)
        collectionView.refreshControl = DefaultRefreshControl(tintColor: ColorPalette.lightBlueColor,
                                                         backgroundColor: collectionView.backgroundColor,
                                                         refreshHandler: { [weak self] in
                                                            self?.refreshMovies()
        })
        self.itemSize = collectionView.frame.size.asCollectionViewItemSize(margin: UIConstants.margin, sizeRatio: UIConstants.itemSizeRatio)
        collectionView.refreshControl?.beginRefreshing()
        self.refreshMovies()
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
        movieClient.getMovies(page: nextPage, listType: MovieList.upcoming) {[weak self] (result : Result<MovieResult?, APIError>) in
            switch result {
            case .success(let movieResult):
                self?.updateDataSource(with: movieResult)
            case .failure( _):
                break
            }
            self?.collectionView?.refreshControl?.endRefreshing(with: 0.5)
        }
    }
    
    func refreshMovies() {
        movieClient.getMovies(page: 1, listType: MovieList.upcoming) {[weak self] (result : Result<MovieResult?, APIError>) in
            switch result {
            case .success(let movieResult):
                self?.updateDataSource(with: movieResult)
            case .failure( _):
                break
            }
            self?.collectionView?.refreshControl?.endRefreshing(with: 0.5)
        }
    }
}
// MARK: -

extension MovieCollectionViewManager: UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView: LoaderCollectionReusableView = collectionView.dequeueSupplementaryView(ofKind: kind, for: indexPath)
        return reusableView
    }
}

// MARK: -

extension MovieCollectionViewManager: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell, let delegate = delegate else { return }
        delegate.showMovieDetails(for: cell, model: dataSource[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        view.isHidden = !dataSource.hasMoreContent
    }
}

// MARK: -

extension MovieCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
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
        let itemsPerRow: Int = {
            if width > 768 { return 4 }
            else if width > 414 { return 3 }
            else { return 2 }
        }()
        let newWidth = (width - (CGFloat(itemsPerRow + 1) * margin)) / CGFloat(itemsPerRow)
        let newHeight = newWidth / sizeRatio
        return CGSize(width: newWidth, height: newHeight)
    }
}
