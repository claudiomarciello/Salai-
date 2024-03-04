//
//  WaitingViuew.swift
//  Salaì
//
//  Created by Claudio Marciello on 25/02/24.
//

import SwiftUI
import UIKit

struct WaitingView: View {
    @State var preprompt: String = "sketch art, line art drawing, line art, black line art, black line, black color, black lines, a line drawing, sketch drawing"
    
    @Binding var prompt: String
    
    @State var progress = 0.0
    @State var generating: Bool = false
    @State var generationEnded: Bool = false
    @State var autoGenerationEnded: Bool = false

    @State var initializing = true
    @State private var rotationAngle: Double = 0

    
    let webUIServerURL = URL(string: "https://87d02e75d92de71421.gradio.live")!
    @State var initImages : [Image] = []
    let outDir = "Results"
    @State var imagepayload: [String] = []
    @State var finalimage: UIImage = UIImage()
    @State var whiteload: [String] = []
    @Binding var shouldAutorun: Bool
    
    //@State var inputImage: CGImage?
    //@State var resultImage: [CGImage]?
    
    var body: some View {
        NavigationStack{

            
            if generating == true{
                Image("Star")
                    .rotationEffect(.degrees(rotationAngle), anchor: .center)
                Text("AI is generating your sketch...")
                    .font(.title)
                    .foregroundStyle(.gray)
                .fontWeight(.bold)}
            else
            {Text("Insert a prompt")
                    .font(.title)
                    .foregroundStyle(.gray)
                .fontWeight(.bold)}
            

            TextEditor(text: $prompt)
                .padding(4)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                )
            
            .padding()
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            startRotation()
                        }
                        DispatchQueue.global(qos: .background).async {
                            generating=true
                            // Convert the image to a UIImage
                            let uiImage = UIImage(named: "white")
                            
                            // Convert the UIImage to Data
                            guard let imageData = uiImage?.pngData() else {
                                print("Failed to convert image to data")
                                return
                            }
                            
                            // Convert the Data to a base64 string
                            whiteload.append(imageData.base64EncodedString())
                            
                            
                            // Call the API functions here
                            //initImages.append(Image("image"))
                            // callTxt2ImgAPI(payload: payloadTxt2Img)
                            //imagepayload.append("white")
                            payloadImg2Img["init_images"] = whiteload
                            if var alwaysonScripts = payloadImg2Img["alwayson_scripts"] as? [String: Any],
                               var controlnet = alwaysonScripts["controlnet"] as? [String: Any],
                               var args = controlnet["args"] as? [[String: Any]],
                               var argsDict = args.first {
                                // Update the value of "input_image"
                                argsDict["input_image"] = imagepayload
                                
                                // Update the nested dictionaries and arrays in the payload
                                args[0] = argsDict
                                controlnet["args"] = args
                                alwaysonScripts["controlnet"] = controlnet
                                payloadImg2Img["alwayson_scripts"] = alwaysonScripts}
                            
                            //      payloadImg2Img["init_images"] = initImages
                            //       payloadImg2Img["batch_size"] = initImages.count
                            payloadImg2Img["prompt"] = payloadImg2Img["prompt"] as! String+" "+prompt
                            
                            callImg2ImgAPI(payload: payloadImg2Img)
                            generationEnded=true
                        }}){HStack {
                            Image(systemName: "wand.and.stars")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .padding(.leading)
                            Text("Generate")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                                .padding()
                            
                        }
                        .frame(width: 200)
                        .background(.black)
                        .opacity(generating || prompt=="" ? 0.4 : 1)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))}
                        .disabled(generating || prompt=="")
                        .navigationDestination(isPresented: $generationEnded){CanvaView(sketch: finalimage, prompt: $prompt, shouldAutorun: $shouldAutorun)}
        }.onAppear{
            if shouldAutorun{
                payloadImg2Img["seed"] = Int.random(in: 0...Int.max)
                DispatchQueue.main.async {
                    startRotation()
                }
                DispatchQueue.global(qos: .background).async {
                    generating=true
                    
                    let image = Image("white")
                    
                    // Convert the image to a UIImage
                    let uiImage = UIImage(named: "white")
                    
                    // Convert the UIImage to Data
                    guard let imageData = uiImage?.pngData() else {
                        print("Failed to convert image to data")
                        return
                    }
                    
                    // Convert the Data to a base64 string
                    whiteload.append(imageData.base64EncodedString())
                    
                    
                    // Call the API functions here
                    //initImages.append(Image("image"))
                    // callTxt2ImgAPI(payload: payloadTxt2Img)
                    //imagepayload.append("white")
                    payloadImg2Img["init_images"] = whiteload
                    if var alwaysonScripts = payloadImg2Img["alwayson_scripts"] as? [String: Any],
                       var controlnet = alwaysonScripts["controlnet"] as? [String: Any],
                       var args = controlnet["args"] as? [[String: Any]],
                       var argsDict = args.first {
                        // Update the value of "input_image"
                        argsDict["input_image"] = imagepayload
                        
                        // Update the nested dictionaries and arrays in the payload
                        args[0] = argsDict
                        controlnet["args"] = args
                        alwaysonScripts["controlnet"] = controlnet
                        payloadImg2Img["alwayson_scripts"] = alwaysonScripts}
                    
                    //      payloadImg2Img["init_images"] = initImages
                    //       payloadImg2Img["batch_size"] = initImages.count
                    payloadImg2Img["prompt"] = payloadImg2Img["prompt"] as! String+" "+prompt
                    
                    callImg2ImgAPI(payload: payloadImg2Img)
                    autoGenerationEnded=true
                }}
            
        
        }
    
            .navigationDestination(isPresented: $autoGenerationEnded){CanvaView(sketch: finalimage, prompt: $prompt, shouldAutorun: $shouldAutorun)}
            
        }

    

    @State var payloadTxt2Img: [String: Any] = [
        "prompt": "wonderful landscape, (best quality:1.1),",
        
        // Add other payload parameters here
    ]
    var outDirT2I: URL {
        let directory = URL(fileURLWithPath: outDir).appendingPathComponent("txt2img")
            print("outDirT2I:", directory)
            return directory
        
    }
    var outDirI2I: URL {
        let directory = URL(fileURLWithPath: outDir).appendingPathComponent("img2img")
            print("outDirI2I:", directory)
            return directory    }

    @State var payloadImg2Img: [String: Any] = [
        "prompt": "sketch art, line art drawing, line art, black line art, black line, black color, black lines, a line drawing, sketch drawing",
        "negative_prompt": " (unrealistic, render, 3d,cgi,cg,2.5d), (bad-hands-5:1.05), easynegative, [( NG_DeepNegative_V1_64T :0.9) :0.1], ng_deepnegative_v1_75t, worst quality, low quality, normal quality, child, hands, fingers (painting, drawing, sketch, cartoon, anime, render, 3d), blurry, deformed, disfigured, morbid, mutated, bad anatomy, bad art, (bad teeth, weird teeth, broken teeth), (weird nipples, twisted nipples, deformed nipples, flat nipples), (worst quality, low quality, logo, text, watermark, username), incomplete,",
        "seed": Int.random(in: 0...Int.max),
        "steps": 20,
        "width": 512,
        "height": 512,
        "denoising_strength": 0.95,
        "n_iter": 1,
        "init_images": [],
        "batch_size": 1,
        "alwayson_scripts": [
            "controlnet": [
                "args": [
                    [
                        "input_image": [],
                        "module": "canny",
                        "model": "control_canny-fp16.safetensors [f2549278df]",
                        "threshold_a": 100,
                        "threshold_b": 200,
                        "pixel_perfect": true,
                        "control_mode": 2

                    ]
                ]
            ]
        ]

        // Add other payload parameters here
    ]

  

   

    func timestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        return dateFormatter.string(from: Date())
    }

    func encodeFileToBase64(path: String) -> String? {
        guard let fileData = FileManager.default.contents(atPath: path) else {
            return nil
        }
        return fileData.base64EncodedString()
    }

    func decodeAndSaveBase64(base64String: String, savePath: URL) {
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Failed to decode base64 string")
            return
        }
        do {
            try imageData.write(to: savePath)
        } catch {
            print("Failed to save image:", error)
        }
    }

    struct APIResponse: Codable {
        let images: [String]
    }

    func callAPI(endpoint: String, payload: [String: Any]) -> APIResponse? {
        let url = webUIServerURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("Failed to serialize JSON:", error)
            return nil
        }
        
        var responseData: Data?
        var responseError: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            responseData = data
            responseError = error
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error = responseError {
            print("API request error:", error)
            return nil
        }
        
        guard let data = responseData else {
            print("No response data")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(APIResponse.self, from: data)
        } catch {
            print("Failed to decode JSON:", error)
            return nil
        }
    }

    func callTxt2ImgAPI(payload: [String: Any]) {
        if let response = callAPI(endpoint: "sdapi/v1/txt2img", payload: payload) {

            let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
                   let outDirT2I = temporaryDirectory.appendingPathComponent("txt2img")
            do {
                try FileManager.default.createDirectory(at: outDirT2I, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("Error creating directory:", error)
                        return
                    }
                
            for (index, image) in response.images.enumerated() {
                let savePath = outDirT2I.appendingPathComponent("txt2img-\(timestamp())-\(index).png")
                
                print(savePath)
                decodeAndSaveBase64(base64String: image, savePath: savePath)
                if let uiImage = UIImage(contentsOfFile: savePath.path),
                   let imageData = uiImage.pngData() {
                    finalimage = uiImage

                    // Convert Data to base64 string
                    let base64String = imageData.base64EncodedString()
                    print(imagepayload.count)

                    imagepayload.append(base64String)
                    print(imagepayload.count)

                } else {
                    print("Failed to initialize UIImage from file at path: \(savePath.path)")
                }

            }
        }
    }

    func callImg2ImgAPI(payload: [String: Any]) {
        print(payloadImg2Img["seed"])
        if let response = callAPI(endpoint: "sdapi/v1/img2img", payload: payload) {
            
            
            let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
                   let outDirI2I = temporaryDirectory.appendingPathComponent("img2img")
            do {
                try FileManager.default.createDirectory(at: outDirI2I, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("Error creating directory:", error)
                        return
                    }
            for (index, image) in response.images.enumerated() {
                let savePath = outDirI2I.appendingPathComponent("img2img-\(timestamp())-\(index).png")
                decodeAndSaveBase64(base64String: image, savePath: savePath)
                if let uiImage = UIImage(contentsOfFile: savePath.path),
                   let imageData = uiImage.pngData() {
                    finalimage = uiImage

                    // Convert Data to base64 string
                    let base64String = imageData.base64EncodedString()
                    print(imagepayload.count)

                    imagepayload.append(base64String)
                    payloadImg2Img["seed"] = payloadImg2Img["seed"] as! Int + 1
                    print(imagepayload.count)

                } else {
                    print("Failed to initialize UIImage from file at path: \(savePath.path)")
                }
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

struct CoolTextEditor: View {
    @State var text: String
    @State private var placeholder: String = "Enter your text"

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }

            TextEditor(text: $text)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    
}


#Preview {
    WaitingView(prompt: .constant(""), finalimage: UIImage(), shouldAutorun: .constant(false))
}
