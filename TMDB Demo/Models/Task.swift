//
//  Task.swift
//  TMDB Demo
//
//  Created by Uttam Ukkoji on 26/05/19.
//  Copyright © 2019 UttamUkkoji. All rights reserved.
//

import Foundation
import RxSwift

public enum Task<T> {
    
    // MARK: - Cases
    
    case loading
    case completed(T)
    
    // MARK: - Initializer
    
    init(_ value: T) {
        self = .completed(value)
    }
}

// MARK: -

extension Task {
    
    // MARK: - Computed properties
    
    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }
    
    var result: T? {
        guard case let .completed(result) = self else { return nil }
        return result
    }
}

// MARK: -
//
//extension ObservableType {
//
//    // MARK: - Materialize as a task
//
//    public func asTask() -> RxSwift.Observable<Task<Self.E>> {
//        return asResult().map { Task.completed($0) }
//    }
//}
