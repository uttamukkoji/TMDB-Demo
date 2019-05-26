//
//  CollectionViewPrefetching.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//
import UIKit

class CollectionViewPrefetching: NSObject, UICollectionViewDataSourcePrefetching {
    
    private let cellCount: Int
    private let prefetchHandler: (() -> Void)
    
    init(cellCount: Int, prefetchHandler: @escaping (() -> Void)) {
        self.cellCount = cellCount
        self.prefetchHandler = prefetchHandler
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= cellCount - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            prefetchHandler()
        }
    }
    
}
