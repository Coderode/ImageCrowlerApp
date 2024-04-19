//
//  ImageCrowlerAPIService.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 19/04/24.
//

import Foundation
protocol ImageCrowlerAPIService {
    func fetchFeeds(offset: Int, limit: Int) async throws -> FeedDataModel
}
