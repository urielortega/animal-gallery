//
//  AnimalProvider.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import Foundation

/// ObservableObject that manages the fetching of photos.
///
/// It acts as a view model that interacts with the AnimalClient to fetch data and keeps track of the current list of photos.
@MainActor
class AnimalProvider: ObservableObject {
    /// Photos currently fetched and available.
    @Published var photos: [AnimalPhoto] = []
    
    /// Client responsible for fetching photos from the remote API.
    let client: AnimalClient
    
    /// Fetches photos from the remote API using AnimalClient. The fetched photos are stored in the `photos` property.
    func fetchPhotos() async throws {
        let latestPhotos = try await client.animalPhotos
        print("latestPhotos count = \(latestPhotos.count)")
        
        self.photos = latestPhotos
    }
    
    /// Initializes a new AnimalProvider instance with an optional custom AnimalClient. If no client is provided, the default is to use a new instance of AnimalClient.
    init(client: AnimalClient = AnimalClient()) {
        self.client = client
    }
}
