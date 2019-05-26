//
//  MovieResultPaginationTests.swift
//  TMDB DemoTests
//
//  Created by Uttam Ukkoji on 27/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import XCTest
@testable import TMDB_Demo

class MovieResultPaginationTests: XCTestCase {
    
    lazy private var movieResult1: MovieResult? = try? jsonDecoded(forResource: "GET_movie_popular_1", withExtension: "json")

    var movieResultUnderTest: MovieResult!
    
    override func setUp() {
        super.setUp()
        movieResultUnderTest = MovieResult(results: [],
                                           currentPage: 1,
                                           totalPages: 2)
    }
    
    override func tearDown() {
        movieResultUnderTest = nil
        super.tearDown()
    }
    
    func testMovieResultHasMorePagesTrue() {
        //Act
        let hasMorePages = movieResultUnderTest.hasMorePages
        //Assert
        XCTAssertTrue(hasMorePages)
    }
    
    func testMovieResultHasMorePagesFalse() {
        //Arrange
        movieResultUnderTest.totalPages = 1
        //Act
        let hasMorePages = movieResultUnderTest.hasMorePages
        //Assert
        XCTAssertFalse(hasMorePages)
    }
    
    func testMovieResultNextPage() {
        //Act
        let nextPage = movieResultUnderTest.nextPage
        //Assert
        XCTAssertEqual(nextPage, 2)
    }
    
    func testProperties() {
        guard let movieResult = movieResult1 else {
            XCTFail()
            return
        }
        
        XCTAssert(movieResult.results.count == 20)
        XCTAssert(movieResult.totalPages == 992)
        XCTAssert(movieResult.hasMorePages == true)
    }
}
