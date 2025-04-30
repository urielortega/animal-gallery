//
//  GalleryView.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var provider: AnimalProvider
    
    @State var isLoading = false
    @State private var error: APIError?
    @State private var hasError = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("GalleryView will show \(provider.photos.count) photos!")
                .padding()
        }
        .task {
            await fetchPhotos()
        }
    }
}

extension GalleryView {
    func fetchPhotos() async {
        isLoading = true
        
        do {
            try await provider.fetchPhotos()
        } catch {
            self.error = error as? APIError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        
        isLoading = false
    }
}


#Preview {
    GalleryView()
        .environmentObject(
            AnimalProvider(
                client: AnimalClient(
                    downloader: TestDownloader()
                )
            )
        )

}
