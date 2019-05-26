//
//  Movie.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation

struct Movie: Decodable, Equatable {
    
    let id: Int
    let title: String
    let genreIds: [Int]?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double?
    
    static let posterAspectRatio: Double = 1.5
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
}

// MARK: - Computed Properties

extension Movie {
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: URLConfiguration.mediaPath + posterPath)
    }
    
    var posterMediumURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: URLConfiguration.mediaMediumPath + posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: URLConfiguration.mediaBackdropPath + backdropPath)
    }
    
}

// MARK: - Constants

extension Movie {
    
    struct Constants {
        static let emptyGenreTitle = "-"
    }
    
}

// MARK: - Test mockups

extension Movie {
    
    static func with(id: Int = 1, title: String = "Movie 1",
                     genreIds: [Int] = [],
                     overview: String = "/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg",
                     posterPath: String = "/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg",
                     backdropPath: String = "path2", releaseDate: String = "02-21-2019",
                     voteAverage: Double = 5.0) -> Movie {
        return Movie(id: id, title: title,
                     genreIds: genreIds,
                     overview: overview, posterPath: posterPath,
                     backdropPath: backdropPath, releaseDate: releaseDate,
                     voteAverage: voteAverage)
    }
    
}
