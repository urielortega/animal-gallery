//
//  APIError.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case missingData
    case networkError
    case decodingError
    case unexpectedError(error: Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL!", comment: "")
        case .missingData:
            return NSLocalizedString("No data was returned from the server.", comment: "")
        case .networkError:
            return NSLocalizedString("Error fetching data over the network.", comment: "")
        case .decodingError:
            return NSLocalizedString("Failed to decode the data.", comment: "")
        case .unexpectedError(let error):
            return NSLocalizedString("Received unexpected error. \(error.localizedDescription)", comment: "")
        }
    }
}
