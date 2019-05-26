//
//  MovieList.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation
enum MovieList {
    case upcoming
    case similar(movieId: Int)
}
