//
//  PortfolioView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI
import PhotosUI
//import UIKit

extension Image {
    func asUIImage() -> UIImage? {
        // Render the SwiftUI Image into a UIImage
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
        let image = renderer.image { context in
            view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}

struct PortfolioView: View {
    @Binding var selected: Int
    @Binding var areImagesLoaded: Bool
    enum SwipeHorizontalDirection: String {
        case right, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }
    
    @State private var avatarPhotoItems: [PhotosPickerItem] = []
    @Binding  var selectedImages: [Image]
    @State var showImages = false

    var viewModel = PortfolioViewModel()
    
    
    
    var body: some View {ZStack{
        ZStack{
            Rectangle().opacity(0.01).frame(width: 1000, height: 600)
                .foregroundStyle(.gray)
            VStack{
                Text("Your")
                    .font(.system(size: 192))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, -40)
                Text("portfolio")
                    .font(.system(size: 192))
                    .fontWeight(.bold)
                    .padding(.top, -40)
                Text("Upload here your illustrations for train your digital support")
                    .font(.title3)
                
                
                
                PhotosPicker("Select images", selection: $avatarPhotoItems, matching: .images)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 250)
                    .background(.black)
                
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                Button(action: {showImages=true}){
                    ZStack{
                        Rectangle().foregroundStyle(.gray)
                            .frame(width: 200, height: 50)
                        Text("Uploads")
                            .fontWeight(.regular)
                            .foregroundStyle(.black)
                            .frame(width: 100, height: 50)
                        
                    }
                }
            }
            .onChange(of: avatarPhotoItems) { _ in
                selectedImages.removeAll()
                Task {
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let sketchesDirectory = documentsDirectory.appendingPathComponent("Sketches")
                        
                        do {
                            print("Sketches directory URL: \(sketchesDirectory)")

                            try FileManager.default.createDirectory(at: sketchesDirectory, withIntermediateDirectories: true, attributes: nil)
                            
                            for (index, item) in avatarPhotoItems.enumerated() {
                                if let loadedImage = try? await item.loadTransferable(type: Image.self) {
                                    print("Loaded image successfully")

                                    if let uiImage = loadedImage.asUIImage() {
                                        print("Converted to UIImage successfully")

                                        let imageData = uiImage.pngData()
                                        let imageURL = sketchesDirectory.appendingPathComponent("sketch\(index).png")
                                        try imageData?.write(to: imageURL)
                                        selectedImages.append(loadedImage)
                                    }else {
                                        print("Failed to convert to UIImage")
                                    }
                                }
                                
                            }
                        } catch {
                            print("Error creating directory: \(error)")
                        }
                    }
                if selectedImages.count > 0{
                    areImagesLoaded = true
                }
                else{
                areImagesLoaded=false}
                
                
            }}
        .gesture(DragGesture()
            .onChanged {
                print("dragging from Portfolio")
                if $0.startLocation.x < $0.location.x {
                    self.swipeHorizontalDirection = .right
                    selected=0
                    
                }})
        VStack{
            Spacer().frame(height: 400)
            }
        }.overlay(
            Group {
                if showImages {
                    ZStack{
                        Rectangle()
                            .opacity(0.2)
                            .frame(width: 1200, height: 1200)
                            .foregroundStyle(.black)
                            .ignoresSafeArea().onTapGesture {
                                showImages = false
                                }
                        
                        
                        
                        
                        
                        RoundedRectangle(cornerRadius: 12.0).foregroundColor(.white)
                            .frame(width: 500, height: 600, alignment: .center)
                        
                        
                        
                        
                        
                        VStack {
                            
                                Text("Your uploads")
                                    .fontWeight(.heavy)
                                    .bold()
                                    .frame(width: 500)
                            
                            if selectedImages.count>0{
                                ScrollView {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                                        ForEach(selectedImages.indices, id: \.self) { index in
                                            selectedImages[index]
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(8)
                                                
                                        }
                                    }
                                    
                                }.frame(width: 500, height: 500, alignment: .center)
                                
                                    .padding()
                                
                            }else{
                                Spacer()
                                Text("No images uploaded in Your Portfolio")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                HStack{
                                    Text("Cancel")
                                    Spacer()
                                        .foregroundStyle(.blue)
                                    Text("Select your reference")
                                        .fontWeight(.heavy)
                                        .bold()
                                    Spacer()
                                    Text("Done")
                                    .foregroundStyle(.blue)
                                    .bold()
                                    
                                }.frame(width: 500)
                                    .opacity(0)
                            }
                            
                            
                            
                            
                        }
                    }
                }}
            
            
        ).frame(height: 650)
            
        }
            
            

            
}


#Preview {
    PortfolioView(selected: .constant(1), areImagesLoaded: .constant(false), selectedImages: .constant([]))
}
