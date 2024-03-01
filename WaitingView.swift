//
//  WaitingViuew.swift
//  Salaì
//
//  Created by Claudio Marciello on 25/02/24.
//

import SwiftUI
import StableDiffusion
import UIKit

struct WaitingView: View {
    @State var preprompt: String = "sketch art, line art drawing, line art, black line art, black line, black color, black lines, a line drawing, sketch drawing"
    
    @State var prompt: String = "a photo of a child looking at the stars"
    @State var pipeline: StableDiffusionPipeline?
    @State var image: CGImage?
    
    @State var progress = 0.0
    @Binding var generating: Bool
    @State var initializing = true
    @State private var rotationAngle: Double = 0

    
    //@State var inputImage: CGImage?
    //@State var resultImage: [CGImage]?
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: CanvaView()){
                Image("Star")
                    .rotationEffect(.degrees(rotationAngle), anchor: .center)
                    .onAppear { startRotation()
                        }}
                
            
            Text("AI is generating your sketch...")
                .font(.title)
                .foregroundStyle(.gray)
                .fontWeight(.bold)
                .onAppear{generateImage()}
            VStack {
                if initializing {
                    Text("Initializing...")
                } else {
                    if let image {
                        Image(image, scale: 1.0, label: Text(""))
                    }
                    if generating {
                        Spacer()
                        ProgressView(value: progress)
                        Text("generating (\(Int(progress*100)) %)")
                    } else {
                        Spacer()
                        TextField("Prompt", text: $prompt)
                        Button("Generate") {
                            generateImage()
                        }
                    }
                }
            }
            .padding()
            .task {
                do {
                    let url = Bundle.main.resourceURL?.appending(path: "model")
                    pipeline = try StableDiffusionPipeline(resourcesAt: url!, controlNet: [], disableSafety: false)
                } catch let error {
                    print(error.localizedDescription)
                }
                initializing = false
            }
        }}

    
    
    
    
    func generateImage(){
            progress = 0.0
            image = nil
            generating = true
            /*let fileURL = Bundle.main.resourceURL?.appending(path: "image")
            
            let startingUIImage = UIImage(named: "dog")
            self.resizeImage(image: startingUIImage!, targetSize: CGSize(width: 512, height: 512))
            guard let startingImage = startingUIImage?.cgImage else {
                return []
            }*/

            Task.detached(priority: .high) {
                var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: preprompt + prompt)
                
                pipelineConfig.negativePrompt = "(unrealistic, render, 3d,cgi,cg,2.5d), (bad-hands-5:1.05), easynegative, [( NG_DeepNegative_V1_64T :0.9) :0.1], ng_deepnegative_v1_75t, worst quality, low quality, normal quality, child, (painting, drawing, sketch, cartoon, anime, render, 3d), blurry, deformed, disfigured, morbid, mutated, bad anatomy, bad art, (bad teeth, weird teeth, broken teeth), (weird nipples, twisted nipples, deformed nipples, flat nipples), (worst quality, low quality, logo, text, watermark, username), incomplete,"
                //pipelineConfig.controlNetInputs = [startingImage]
                //pipelineConfig.startingImage = startingImage
                // 4
                pipelineConfig.useDenoisedIntermediates = true
                // 5
                pipelineConfig.strength = 0.9
                pipelineConfig.seed = UInt32.random(in: (0..<UInt32.max))
                // 6
                pipelineConfig.guidanceScale = 7.5
                pipelineConfig.stepCount = 25
                pipelineConfig.originalSize = 512
                pipelineConfig.targetSize = 512

                var images: [CGImage?]?
                do {
                    images = try pipeline?.generateImages(configuration: pipelineConfig, progressHandler: { progress in
                        self.progress = Double(progress.step) / 25
                        if let image = progress.currentImages.first {
                            self.image = image
                        }
                        return true
                    })
                } catch let error {
                    print(error.localizedDescription)
                }
                if let image = images?.first {
                    self.image = image
                    generating = false

                }
            }
        }
    func startRotation() {
            // Start a timer to update the rotation angle continuously
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                // Update rotation angle
                rotationAngle += 1 // Adjust the speed of rotation by changing the increment value
            }
        }

}


#Preview {
    WaitingView(generating: .constant(true))
}
