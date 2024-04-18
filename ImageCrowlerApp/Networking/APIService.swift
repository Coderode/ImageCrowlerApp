//
//  APIService.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation

enum HttpMethodType: String {
    case get = "GET"
    case post = "POST"
}
enum NetworkError: String, Error {
    case NoInternet
    case SomethingWentWrong
}

protocol APIFetchService : AnyObject {
    associatedtype AnyType : Codable
    func fetchData(queryParams: [String: String], url: URL) async throws -> AnyType
    func fetchData(url: URL) async throws -> Data
}


class APIFetchServiceImpl<T : Codable>: APIFetchService {
    func fetchData(queryParams: [String : String], url: URL) async throws -> T {
        var urlComponents = URLComponents(string: url.absoluteString)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        let data = try await self.fetchData(url: url)
        do {
            let feeds = try JSONDecoder().decode(T.self, from: data)
            return feeds
        } catch {
            let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw error
        }
    }
    
    func fetchData(url: URL) async throws -> Data {
        guard NetworkReachabilityManager.isConnectedToNetwork() else {
            throw NetworkError.NoInternet
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethodType.get.rawValue
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
