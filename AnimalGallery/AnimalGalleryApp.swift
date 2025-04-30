//
//  AnimalGalleryApp.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import SwiftUI

@main
struct AnimalGalleryApp: App {
    @StateObject var animalProvider = AnimalProvider()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(animalProvider)
        }
    }
}
