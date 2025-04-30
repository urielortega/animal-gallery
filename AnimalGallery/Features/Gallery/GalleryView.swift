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
        NavigationStack {
            List {
                ForEach(provider.photos) { photo in
                    NavigationLink {
                        DetailView()
                    } label: {
                        HStack {
                            Text(photo.description ?? "No description")
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: photo.smallImageURL), scale: 3) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100) // To save the space for the image and the progress indicator.
                            .accessibilityHidden(true) // To make the view invisible to the accessibility system.
                        }
                        
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Animal Gallery")
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
