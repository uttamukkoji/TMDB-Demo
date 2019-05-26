//
//  MovieDetailTests.swift
//  TMDB DemoTests
//
//  Created by Uttam Ukkoji on 27/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import XCTest
@testable import TMDB_Demo


fileprivate let validFilmJsonString =
"""
{
"vote_count": 851,
"id": 338970,
"video": false,
"vote_average": 6.1,
"title": "Tomb Raider",
"popularity": 139.161412,
"poster_path": "/ePyN2nX9t8SOl70eRW47Q29zUFO.jpg",
"original_language": "en",
"original_title": "Tomb Raider",
"genre_ids": [
28,
12
],
"backdrop_path": "/yVlaVnGRwJMxB3txxwA24XurSNp.jpg",
"adult": false,
"overview": "Lara Croft, the fiercely independent daughter of a missing adventurer, must push herself beyond her limits when she finds herself on the island where her father disappeared.",
"release_date": "2018-03-08"
}
"""

fileprivate let invalidFilmJsonString =
"""
{
"vote_count": 851,
"video": false,
"vote_average": 6.1,
"title": "Tomb Raider",
"popularity": 139.161412,
"poster_path": "/ePyN2nX9t8SOl70eRW47Q29zUFO.jpg",
"original_language": "en",
"original_title": "Tomb Raider",
"genre_ids": [
28,
12
],
"backdrop_path": "/yVlaVnGRwJMxB3txxwA24XurSNp.jpg",
"adult": false,
"overview": "Lara Croft, the fiercely independent daughter of a missing adventurer, must push herself beyond her limits when she finds herself on the island where her father disappeared.",
"release_date": "2018-03-08"
}
"""

class MovieDetailTests: XCTestCase {
    
    private var viewModelToTest: Movie!
    
    override func setUp() {
        super.setUp()
        viewModelToTest = Movie(id: 1,
                                title: "Test 1",
                                genreIds: [1, 2],
                                overview: "Overview",
                                posterPath: "/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg",
                                backdropPath: "/2Ah63TIvVmZM3hzUwR5hXFg2LEk.jpg",
                                releaseDate: "2019-02-01", voteAverage: 4.5)
    }
    
    override func tearDown() {
        viewModelToTest = nil
        super.tearDown()
    }
    
    func testMovieDetailTitle() {
        //Act
        let title = viewModelToTest.title
        //Assert
        XCTAssertEqual(title, "Test 1")
    }
    
    func testMovieDetailReleaseDate() {
        //Act
        let releaseDate = viewModelToTest.releaseDate
        //Assert
        XCTAssertEqual(releaseDate, "2019-02-01")
    }
    
    func testMovieDetailOverview() {
        //Act
        let overview = viewModelToTest.overview
        //Assert
        XCTAssertEqual(overview, "Overview")
    }
    
    func testMovieDetailVoteAverage() {
        //Act
        let voteAverage = viewModelToTest.voteAverage
        //Assert
        XCTAssertEqual(voteAverage, 4.5)
    }
    
    func testMovieDetailPosterPath() {
        //Act
        let fullPosterPath = viewModelToTest.posterURL
        //Assert
        XCTAssertEqual(fullPosterPath!, URL(string: "https://image.tmdb.org/t/p/w185/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg"))
    }
    
    func testMovieDetailBackdropPath() {
        //Act
        let fullBackdropPath = viewModelToTest.backdropURL
        //Assert
        XCTAssertEqual(fullBackdropPath!, URL(string: "https://image.tmdb.org/t/p/w500/2Ah63TIvVmZM3hzUwR5hXFg2LEk.jpg"))
    }
    
    func testProperties() {
        
        guard
            let jsonData = validFilmJsonString.data(using: .utf8),
            let movie = try? JSONDecoder().decode(Movie.self, from: jsonData) else {
                XCTFail()
                return
        }
        
        XCTAssert(movie.id == 338970)
        XCTAssert(movie.voteAverage == 6.1)
        XCTAssert(movie.title == "Tomb Raider")
        XCTAssert(movie.genreIds == [28, 12])
        XCTAssert(movie.backdropPath == "/yVlaVnGRwJMxB3txxwA24XurSNp.jpg")
        XCTAssert(movie.posterPath == "/ePyN2nX9t8SOl70eRW47Q29zUFO.jpg")
        XCTAssert(movie.overview == "Lara Croft, the fiercely independent daughter of a missing adventurer, must push herself beyond her limits when she finds herself on the island where her father disappeared.")
    }
    
    func testFailingInitialization() {
        
        guard let jsonData = invalidFilmJsonString.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(Movie.self, from: jsonData))
    }
}

