//
//  ImageCrowlerVM.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 16/04/24.
//

import Foundation
import UIKit

class ImageCrowlerVM {
    var feeds : ObservableCollection<FeedDataModel> = ObservableCollection([])
    var apiError: Observable<Error?> = Observable(nil)
    var apiService: ImageCrowlerAPIService
    var isLoadingAPI : Bool = false
    var newlyAddedIndexPaths : ObservableCollection<[IndexPath]> = ObservableCollection([])
    private var offset = 0
    init(apiService: ImageCrowlerAPIService) {
        self.apiService = apiService
    }
    func fetchFeeds() {
        guard !isLoadingAPI else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                self.isLoadingAPI = true
                var newIndexPaths: [IndexPath] = []
                let startIndex = self.feeds.value.count
                let posts = try await self.apiService.fetchFeeds(offset: self.offset, limit: 100)
                self.feeds.append(posts)
                self.offset = self.feeds.value.count
                self.isLoadingAPI = false
                let endIndex = startIndex + posts.count - 1
                for index in startIndex...endIndex {
                    newIndexPaths.append(IndexPath(item: index, section: 0))
                }
                self.newlyAddedIndexPaths.value = newIndexPaths
            } catch let error {
                self.apiError.value = error
                self.isLoadingAPI = false
            }
        }
    }
    func refreshData() {
        self.feeds.value = []
        self.newlyAddedIndexPaths.value = []
        self.offset = 0
    }
}
