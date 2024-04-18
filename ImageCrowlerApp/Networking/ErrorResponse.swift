//
//  ErrorResponse.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 18/04/24.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Error, Codable {
    let code: Int
    let error: String
}
