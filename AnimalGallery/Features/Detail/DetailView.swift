//
//  DetailView.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import SwiftUI

struct DetailView: View {
    let animalPhoto: AnimalPhoto
    @State private var isPressed = false
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: animalPhoto.regularImageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(isPressed ? 0.96 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPressed)
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.01)
                            .onChanged { _ in isPressed = true }
                            .onEnded { _ in isPressed = false }
                    )
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 300)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let description = animalPhoto.description {
                    VStack(alignment: .leading) {
                        Text("Description:")
                            .font(.headline)
                        Text(description)
                    }
                    .padding(.vertical)
                }
                
                Text("Author:")
                    .font(.headline)
                Text(animalPhoto.user.username)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

