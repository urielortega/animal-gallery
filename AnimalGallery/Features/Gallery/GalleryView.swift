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
    
    let layout = [
        GridItem(
            .adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 160)
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(provider.photos) { animalPhoto in
                        NavigationLink {
                            DetailView()
                                .padding(5)
                        } label: {
                            AnimalPhotoLabel(animalPhoto: animalPhoto)
                        }
                    }
                }
            }
            .navigationTitle("Animal Gallery")
        }
        .task {
            await fetchPhotos()
        }
    }
}

extension GalleryView {
    struct AnimalPhotoLabel: View {
        var animalPhoto: AnimalPhoto
        
        var body: some View {
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: animalPhoto.smallImageURL), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .padding()
                .frame(height: 120) // To save the space for the image and the progress indicator.
                .padding()
                
                Spacer()
                
                Text(animalPhoto.description ?? "No description")
                    .font(.caption)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .foregroundStyle(Color(.label)) // To show an appropriate color in both light and dark mode.
            .cornerRadius(22)
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.gray.gradient.opacity(0.1), lineWidth: 3)
                    .shadow(radius: 2)
            }
            .padding()
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
