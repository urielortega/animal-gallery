//
//  AnimalGalleryTests.swift
//  AnimalGalleryTests
//
//  Created by Uriel Ortega on 29/04/25.
//

import XCTest
@testable import AnimalGallery

class AnimalGalleryTests: XCTestCase {
    func testJSONDecoderDecodesAnimalPhoto() throws {
        let decoder = JSONDecoder()

        // The decoder checks that the types in the JSON match the types expected by the AnimalPhoto struct. If any required fields are missing or of the wrong type, the decoder throws an error:
        let animalPhoto = try decoder.decode(AnimalPhoto.self, from: testAnimalPhoto)
        
        let expectedAltDescription = "red and brown rooster head in closeup shot"
        XCTAssertEqual(animalPhoto.altDescription, expectedAltDescription)
        
        let expectedSmallImageURL = "https://images.unsplash.com/photo-1462027076063-1ceabb252dbd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3NDQ4MDZ8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NDU5NTU2OTl8&ixlib=rb-4.0.3&q=80&w=400"
        XCTAssertEqual(animalPhoto.smallImageURL, expectedSmallImageURL)
        
        let containsAnimals = animalPhoto.topics.contains { $0.name.lowercased() == "animals" }
        XCTAssertTrue(containsAnimals, "The topics should contain 'animals'")
    }
    
    func testClientDoesFetchAnimalPhotoData() async throws {
        let downloader = TestDownloader()
        let client = AnimalClient(downloader: downloader)
        let animalPhotos = try await client.animalPhotos
        
        XCTAssertEqual(animalPhotos.count, 2)
    }
}
