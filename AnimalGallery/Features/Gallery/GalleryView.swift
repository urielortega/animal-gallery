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
    @State private var isLoadingMore = false
    @State private var error: APIError?
    @State private var hasError = false
    
    private let layout = [
        GridItem(
            .adaptive(minimum: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 160)
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 300)
                } else if hasError {
                    VStack {
                        Text("Ocurrió un error")
                            .font(.headline)
                        Text(error?.localizedDescription ?? "Error desconocido")
                            .font(.subheadline)
                        Button("Reintentar") {
                            Task { await fetchPhotos() }
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    LazyVGrid(columns: layout) {
                        ForEach(provider.photos) { animalPhoto in
                            NavigationLink {
                                DetailView(animalPhoto: animalPhoto)
                                    .padding()
                            } label: {
                                AnimalPhotoLabel(animalPhoto: animalPhoto)
                            }
                        }
                    }
                    
                    if isLoadingMore {
                        ProgressView()
                            .padding()
                    } else {
                        Button("Cargar más") {
                            Task {
                                await loadMorePhotos()
                            }
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    
                    
                }
            }
            .navigationTitle("Animal Gallery")
        }
        .task {
            await fetchPhotos()
        }
//        .refreshable {
//            await fetchPhotos()
//        }
        .alert(isPresented: $hasError, error: error) {}
        
    }
}

// LABELS:
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
                .frame(height: 100) // To save the space for the image and the progress indicator.
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .foregroundStyle(Color(.label)) // To show an appropriate color in both light and dark mode.
            .cornerRadius(22)
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.gray.gradient.opacity(0.2), lineWidth: 3)
                    .shadow(radius: 2)
            }
            .padding()
            .accessibilityElement()
            .accessibilityLabel(
                "Description: \(animalPhoto.description ?? "No description")"
            )
            .accessibilityHint("Photo taken by: \(animalPhoto.user)")
            
        }
    }
}

// LOGIC
// TODO: Move to a ViewModel
private extension GalleryView {
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
    
    func loadMorePhotos() async {
        isLoadingMore = true
        do {
            try await provider.fetchMorePhotos()
        } catch {
            self.error = error as? APIError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoadingMore = false
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
