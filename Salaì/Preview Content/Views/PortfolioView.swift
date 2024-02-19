//
//  PortfolioView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI

struct PortfolioView: View {
    @Binding var selected: Int
    enum SwipeHorizontalDirection: String {
        case right, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }
    @State private var avatarPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    

    var viewModel = PortfolioViewModel()
    
    var body: some View {
        VStack{
            Text("Your portfolio")
                        
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
            
        }
            .gesture(DragGesture()
                .onChanged {
                    print("dragging from Portfolio")
                    if $0.startLocation.x < $0.location.x {
                        self.swipeHorizontalDirection = .right
                        selected=0
                        
                    }})
    }
}


#Preview {
    PortfolioView(selected: .constant(0))
}
