//
//  HTTPDataDownloader.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import Foundation

let validStatus = 200...299 // Codes in the range 200–299 indicate successful requests.

/// A protocol for downloading data from a URL.
protocol HTTPDataDownloader {
    /// Downloads data from a given URL.
    /// - Parameter from: The URL to download data from.
    /// - Returns: The downloaded data.
    func httpData(from: URL) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data {
        let (data, response) = try await self.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              validStatus.contains(httpResponse.statusCode) else {
            throw APIError.networkError
        }
        
        return data
    }
}
