//
//  ContentView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI



struct ContentView: View {
   // @Binding var generating: Bool
    @State var Images: [Image] = []
    @State var selected = 0
    @State var isOverlayVisible = false
    @State var areImagesLoaded = false
    @State var SelectedImage: Image? = nil
    @State var prompt = ""
    @State var shouldAutorun = false
    
    let filterOptions: [String] = ["Ai Results","Portfolio"]
    enum SwipeHorizontalDirection: String {
        case left, right, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }
    
    
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.black
        
        let attributes:[NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.white,
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        UISegmentedControl.appearance().backgroundColor = UIColor.init(white: 1, alpha: 1)
        UISegmentedControl.appearance().layer.cornerRadius = 100
       // self._generating = generating
        
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(selected==0 ? "AiResults": "Portfolio")
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                VStack{
                    Picker(selection: $selected,
                           label: Text("Picker"),
                           content: {
                        ForEach(filterOptions.indices){ index in Text(filterOptions[index])
                                .tag(filterOptions[index])
                            
                        }
                        
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .frame(width:800)
                    
                    
                    if selected == 0{
                        AiResultsView(isOverlayVisible: $isOverlayVisible, areImagesLoaded: $areImagesLoaded, selected: $selected).frame(height: 600)
                    }
                    else{
                        PortfolioView(selected: $selected, areImagesLoaded: $areImagesLoaded, selectedImages: $Images).frame(height: 600)
                    }
                    // }
                }}.ignoresSafeArea()
                .blur(radius: isOverlayVisible ? 5 : 0)
                .overlay(
                    Group {
                        if isOverlayVisible {
                            ZStack{
                                Rectangle()
                                    .opacity(0.2)
                                    .frame(width: 1200, height: 1200)
                                    .foregroundStyle(.black)
                                    .ignoresSafeArea().onTapGesture {
                                        isOverlayVisible = false
                                        print(isOverlayVisible)}
                                
                                
                                
                                
                                
                                RoundedRectangle(cornerRadius: 12.0).foregroundColor(.white)
                                    .frame(width: 500, height: 600, alignment: .center)
                                
                                
                                
                                
                                
                                VStack {
                                    HStack{
                                        Button("Cancel"){
                                            SelectedImage=nil
                                            isOverlayVisible=false
                                        }
                                        Spacer()
                                            .foregroundStyle(.blue)
                                        Text("Select your reference")
                                            .fontWeight(.heavy)
                                            .bold()
                                        Spacer()
                                        Button("Done"){
                                            //generating=true
                                        }
                                        .foregroundStyle(.blue)
                                        .bold()
                                        
                                    }.frame(width: 500)
                                    
                                    if Images.count>0{
                                        ScrollView {
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                                                ForEach(Images.indices, id: \.self) { index in
                                                    Images[index]
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(8)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color.blue, lineWidth: SelectedImage == Images[index] ? 3 : 0)
                                                        )
                                                        .onTapGesture {
                                                            // Set the selected image
                                                            SelectedImage = Images[index]
                                                            print("Selected image: \(SelectedImage)")
                                                        }
                                                }
                                            }
                                            
                                        }.frame(width: 500, height: 500, alignment: .center)
                                        
                                            .padding()
                                        
                                    }else{
                                        Spacer()
                                        Text("No images uploaded in Your Portfolio")
                                            .font(.headline)
                                            .foregroundStyle(.gray)
                                        
                                        NavigationLink(destination: WaitingView(prompt: $prompt, shouldAutorun: $shouldAutorun), label:
                                        {
                                            HStack{
                                                Image(systemName: "wand.and.stars")
                                                    .resizable()
                                                    .foregroundStyle(.white)
                                                    .frame(width: 30, height: 30)
                                                    .padding(.leading)
                                                Text("Proceed anyway")
                                                    .font(.body)
                                                    .fontWeight(.regular)
                                                    .foregroundStyle(.white)
                                                    .padding()
                                            }
                                            .frame(width: 250)
                                            .background(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                        })
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
        }}}
    

#Preview {
    ContentView()
}
