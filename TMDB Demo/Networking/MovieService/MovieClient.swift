//
//  MovieClient.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation

class MovieClient: TMDBClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // MARK: - Movie list
    
    func getMovies(page: Int, listType: MovieList, completion: @escaping (Result<MovieResult?, APIError>) -> Void) {
        let request = getMovieListRequest(with: listType, page: page)
        fetch(with: request, decode: { json -> MovieResult? in
            guard let movieResult = json as? MovieResult else { return  nil }
            return movieResult
        }, completion: completion)
    }
    
    private func getMovieListRequest(with listType: MovieList, page: Int) -> URLRequest {
        switch listType {
        case .upcoming:
            return MovieEndPoint.getUpcoming(page: page).request
        case .similar(let movieId):
            return MovieEndPoint.getSimilars(page: page, id: movieId).request
        }
    }
}

