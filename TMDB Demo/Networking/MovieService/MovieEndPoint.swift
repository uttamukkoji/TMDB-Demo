//
//  MovieEndPoint.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation

enum MovieEndPoint {
    
    case getUpcoming(page: Int)
    case getSimilars(page:Int, id: Int)

}

extension MovieEndPoint: Endpoint {
    
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .getUpcoming:
            return "/3/movie/upcoming"
        case .getSimilars(_, let id):
            return "/3/movie/\(id)/similar"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .getUpcoming(let page):
            return ["page": page]
        case .getSimilars(let page, _):
            return ["page": page]
        }
    }
    
    var parameterEncoding: ParameterEnconding {
        return .defaultEncoding
    }
    
    var method: HTTPMethod {
        return .get
    }
    
}
