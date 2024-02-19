//
//  ContentView.swift
//  Salaì
//
//  Created by Claudio Marciello on 19/02/24.
//
import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var avatarPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    
    var body: some View {
        VStack {
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(selectedImages.indices, id: \.self) { index in
                        selectedImages[index]
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Rectangle())
                    }
                }
            }
            .padding()
            
            PhotosPicker("Select images",
                         selection: $avatarPhotoItems,
                         matching: .images)
        }
        .onChange(of: avatarPhotoItems) { _ in
            selectedImages.removeAll()
            Task {
                for item in avatarPhotoItems {
                    if let loadedImage = try? await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
