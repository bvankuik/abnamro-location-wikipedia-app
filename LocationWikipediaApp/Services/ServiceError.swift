//
//  ServiceError.swift
//  TestLeapML
//
//  Created by Bart van Kuik on 09/02/2023.
//

import Foundation

/// Thrown when we receive an unexpected HTTP error code, or when something goes wrong decoding
enum ServiceError: Error {
    case failed(message: String)
}
