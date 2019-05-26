//
//  LoaderCollectionReusableView.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import UIKit

final class LoaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Properties
    
    static let height: CGFloat = 85.0
    
    // MARK: - UICollectionReusableView life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        label.font = FontHelper.regular(withSize: 12.0)
        label.textColor = UIColor.gray
        activityIndicatorView.tintColor = UIColor.gray
        activityIndicatorView.hidesWhenStopped = true
    }
}

extension LoaderCollectionReusableView: NibLoadableView { }

extension LoaderCollectionReusableView: ReusableView { }
