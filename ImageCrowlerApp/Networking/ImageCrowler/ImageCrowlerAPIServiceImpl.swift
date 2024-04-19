//
//  ImageCrowlerAPIServiceImpl.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
import UIKit

class ImageCrowlerAPIServiceDefaultImpl : ImageCrowlerAPIService {
    private var apiService = APIFetchServiceImpl<FeedDataModel>()
    func fetchFeeds(offset: Int, limit: Int = 100) async throws -> FeedDataModel {
        let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages")!
        var queryParams = [String: String]()
        queryParams["limit"] = "\(limit)"
        queryParams["offset"] = "\(offset)"
        let feeds = try await self.apiService.fetchData(queryParams: queryParams, url: url)
        return feeds
    }
}
