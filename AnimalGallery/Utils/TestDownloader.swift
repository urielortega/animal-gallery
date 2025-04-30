//
//  TestDownloader.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import Foundation

class TestDownloader: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data { // Ignores the 'url' property...
        try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000))
        return testAnimalPhotos // ...because it returns the 'testAnimalPhotos' constant property.
    }
}
