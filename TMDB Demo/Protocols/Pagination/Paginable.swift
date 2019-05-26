//
//  Paginable.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation

protocol Paginable {
    
    var currentPage: Int { get set }
    var totalPages: Int { get set }
    
}

extension Paginable {
    
    var hasMorePages: Bool {
        return currentPage < totalPages
    }
    
    var nextPage: Int {
        return hasMorePages ? currentPage + 1 : currentPage
    }
    
}
