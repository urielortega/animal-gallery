//
//  AnimalClient.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import Foundation

/// A client responsible for fetching photos from a remote API.
///
/// `AnimalClient` handles the network requests to retrieve data from the remote API and decodes the JSON response into `AnimalPhoto` models.
///
/// - Note: The client uses dependency injection to allow for easy testing and customization of the network layer.
class AnimalClient {
    private var feedURL: URL? {
        var components = URLComponents(string: "https://api.unsplash.com/photos/random")
        components?.queryItems = [
            URLQueryItem(name: "query", value: "animals"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "client_id", value: Secrets.unsplashAPIKey)
        ]
        return components?.url
    }
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        return aDecoder
    }()
    
    private let downloader: any HTTPDataDownloader  // AnimalClient is DEPENDENT on something that conforms to HTTPDataDownloader. (Dependency Injection)
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) { // The downloader defaults to URLSession.shared.
        self.downloader = downloader
        // print("URL used for API call: \(feedURL?.absoluteString ?? "No URL found...")")
    }
    
    var animalPhotos: [AnimalPhoto] {
        get async throws {
            guard let url = feedURL else {
                // print("INVALID URL!")
                throw APIError.invalidURL
            }

            do {
                // print("ENTERED RETRIEVING!")

                let data = try await downloader.httpData(from: url)
                let allAnimalPhotos = try decoder.decode([AnimalPhoto].self, from: data)
                
                // print("ABOUT TO RETURN allAnimalPhotos")

                return allAnimalPhotos
            } catch {
                // print("Error fetching or decoding animal photos: \(error)")
                throw APIError.decodingError
            }
        }
    }
}
