//
//  AiResultsView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI
import PhotosUI

struct AiResultsView: View {
   // @Binding var generating: Bool
    @Binding var isOverlayVisible: Bool
    @State var showResults: Bool = false
    @State  var results: [Image] = []
    @Binding var areImagesLoaded: Bool
    @State var shouldAutorun = false
    @Binding var selected: Int
    @State var prompt: String = ""
    enum SwipeHorizontalDirection: String {
        case left, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }
    
    var viewModel = AiResultsViewModel()
    
    var body: some View {
        ZStack{
            Rectangle().opacity(0.01).frame(width: 1000, height: 600)
                .foregroundStyle(.gray)
            VStack{
                Text("Ai")
                    .font(.system(size: 192))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, -40)
                Text("results")
                    .font(.system(size: 192))
                    .fontWeight(.bold)
                    .padding(.top, -40)
                
                
                if areImagesLoaded==false {
                    NavigationLink(destination: WaitingView(prompt: $prompt, finalimage: UIImage(), shouldAutorun: $shouldAutorun), label:{
                        HStack{
                            Image(systemName: "wand.and.stars")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .padding(.leading)
                            Text("Generate a new sketch")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(width: 250)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    })
                } else {
                    Button(action: {
                            isOverlayVisible=true})
                    {
                        HStack{
                            Image(systemName: "wand.and.stars")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .padding(.leading)
                            Text("Generate a new sketch")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(width: 250)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    }}
                Button(action: {showResults=true}){
                    ZStack{
                        Rectangle().foregroundStyle(.gray)
                            .frame(width: 200, height: 50)
                        Text("Results")
                            .fontWeight(.regular)
                            .foregroundStyle(.black)
                            .frame(width: 100, height: 50)
                        
                    }
                }
                
                
                
            }}
            .gesture(DragGesture()
                .onChanged {
                    print("dragging from aiResults")
                    if $0.startLocation.x > $0.location.x {
                        self.swipeHorizontalDirection = .left
                        selected=1
                        
                    }})
            .overlay(
                Group {
                    if showResults {
                        ZStack{
                            Rectangle()
                                .opacity(0.2)
                                .frame(width: 1200, height: 1200)
                                .foregroundStyle(.black)
                                .ignoresSafeArea().onTapGesture {
                                    showResults = false
                                    }
                            
                            
                            
                            
                            
                            RoundedRectangle(cornerRadius: 12.0).foregroundColor(.white)
                                .frame(width: 500, height: 600, alignment: .center)
                            
                            
                            
                            
                            
                            VStack {
                                
                                    Text("Results")
                                        .fontWeight(.heavy)
                                        .bold()
                                        .frame(width: 500)
                                
                                if results.count>0{
                                    ScrollView {
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                                            ForEach(results.indices, id: \.self) { index in
                                                results[index]
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
    AiResultsView(isOverlayVisible: .constant(false), results: [], areImagesLoaded: .constant(false), selected: .constant(0))
}
