//
//  Result.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation
public enum Result<Success, Failure> {
    /// A success, storing a `Value`.
    case success(Success)
    
    /// A failure, storing an `Error`.
    case failure(Failure)
}
