//
//  GalleryView.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import SwiftUI

struct GalleryView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, GalleryView!")
                .padding()
        }
        .padding()
    }
}

#Preview {
    GalleryView()
}
