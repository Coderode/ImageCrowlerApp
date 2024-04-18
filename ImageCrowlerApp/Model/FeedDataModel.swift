//
//  FeedDataModel.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation

// MARK: - FeedDataModelElement
struct FeedDataModelElement: Codable {
    let id, title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

// MARK: - BackupDetails
struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Float
}

typealias FeedDataModel = [FeedDataModelElement]
