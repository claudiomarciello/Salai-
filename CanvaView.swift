import SwiftUI
import PencilKit
import UIKit
import SwiftData

struct ShareButton: View {
    var shareItems: [Any]
    var body: some View {
        Button {
            
            let activityController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }
            if let windowScene = scene as? UIWindowScene {
                activityController.popoverPresentationController?.sourceView = windowScene.keyWindow
                activityController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width*0.99, y: 0, width: 1, height: 1)
                windowScene.keyWindow?.rootViewController?.present(activityController, animated: true, completion: nil)
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
}

struct CanvaView: View {

    @State private var canvas = PKCanvasView()
    @State private var isDrawing = true
    @State private var color: Color = .black
    @State private var pencilType: PKInkingTool.InkType = .pencil
    @State private var colorPicker = false
    @State var sketch: UIImage
    @State private var isSaved = false
    @State private var selectedTool: PKInkingTool?
    @State var toShare: [UIImage] = []
    @Binding var prompt: String
    @Binding var shouldAutorun: Bool
    @Environment(\.presentationMode) var presentationMode

    @State private var canvasView: PKCanvasView = {
        let view = PKCanvasView()
        view.drawingPolicy = .anyInput
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .foregroundColor(.black)
                                .frame(width: 100, height: 50)
                            
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                            
                        }
                        Spacer()
                    })
                    NavigationLink(destination: WaitingView(prompt: $prompt, shouldAutorun: .constant(true)), label:{
                        ZStack {
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }})
                    Spacer()
                    Button {
                        toShare.removeAll()
                        self.saveDrawingAsPNG(sketch: sketch)
                        let activityController = UIActivityViewController(activityItems: toShare, applicationActivities: nil)
                        let allScenes = UIApplication.shared.connectedScenes
                        let scene = allScenes.first { $0.activationState == .foregroundActive }
                        if let windowScene = scene as? UIWindowScene {
                            activityController.popoverPresentationController?.sourceView = windowScene.keyWindow
                            activityController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width*0.99, y: 0, width: 1, height: 1)
                            windowScene.keyWindow?.rootViewController?.present(activityController, animated: true, completion: nil)
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                    }
                }.padding(10)
                ZStack{
                    Image(uiImage: sketch).resizable()
                    
                        .overlay(
                            CanvasRepresentable(canvasView: $canvasView, selectedTool: $selectedTool).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                .edgesIgnoringSafeArea(.all)
                            
                            //   .border(Color.gray) // Optional: add a border
                                .onAppear {
                                    canvasView.tool = selectedTool ?? PKInkingTool(.pen, color: .black, width: 15)
                                    canvasView.becomeFirstResponder()
                                }).opacity(0.7)
                    
                    
                    
                    
                }.scaledToFit()
                    .padding(.vertical, 10)
                

            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func saveDrawing() {
        // Get the drawing from the canvas
        let drawing = canvasView.drawing
        
        // Convert the PKDrawing to Data
        do {
            let data = try drawing.dataRepresentation()
            
            // Save the data to a file or perform any other desired action
            // For example, you can save it to the documents directory
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("drawing.pk")
            
            try data.write(to: fileURL)
            print("Drawing saved at: \(fileURL)")
        } catch {
            print("Error saving drawing: \(error)")
        }
    }
    
    func loadDrawing() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("drawing.pk")
        
        do {
            // Read data from the file
            let data = try Data(contentsOf: fileURL)
            
            // Convert data to PKDrawing
            let drawing = try PKDrawing(data: data)
            
            // Set the drawing to the canvas
            canvasView.drawing = drawing
        } catch {
            print("Error loading drawing: \(error)")
        }
    }
    
    
    func saveImageAsPNG(image: UIImage, filename: String) {
        guard let pngData = image.pngData() else {
            print("Failed to convert image to PNG data")
            return
        }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try pngData.write(to: fileURL)
            print("\(filename) saved at: \(fileURL)")
        } catch {
            print("Error saving \(filename) as PNG: \(error)")
        }
    }
    
    func saveDrawingAsPNG(sketch: UIImage) {
        
        /*
         let backgroundImage = sketch
         let drawing = canvasView.drawing
         
         // Get the size of the canvas
         let canvasSize = canvasView.bounds.size
         
         // Calculate the scale factor for the drawing
         let scaleFactor = max(sketch.size.width / canvasSize.width, sketch.size.height / canvasSize.height)
         
         // Calculate the size of the drawing in the canvas coordinate system
         let drawingSize = CGSize(width: drawing.bounds.width / scaleFactor, height: drawing.bounds.height / scaleFactor)
         
         // Calculate the position of the drawing in the canvas coordinate system
         let drawingOrigin = CGPoint(x: (canvasSize.width - drawingSize.width) / 2, y: (canvasSize.height - drawingSize.height) / 2)
         
         // Create a drawing context with the canvas size
         UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
         
         // Draw the background image
         backgroundImage.draw(in: CGRect(origin: .zero, size: canvasSize))
         
         // Draw the drawing image centered on the canvas
         drawing.image(from: CGRect(origin: drawingOrigin, size: drawingSize), scale: 1.0).draw(at: drawingOrigin)
         
         // Get the merged image from the context
         let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
         
         // End the context
         UIGraphicsEndImageContext()
         
         if let mergedImage = mergedImage {
         toShare.append(mergedImage)
         }
         
         toShare.append(backgroundImage)
         toShare.append(drawing.image(from: drawing.bounds, scale: 1.0))
         // Convert the UIImage to PNG data
         guard let pngData = mergedImage?.pngData() else {
         print("Failed to convert image to PNG data")
         return
         }
         
         // Save the PNG data to a file
         let fileManager = FileManager.default
         let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
         let fileURL = documentsURL.appendingPathComponent("drawing.png")
         
         do {
         try pngData.write(to: fileURL)
         print("Drawing saved as PNG at: \(fileURL)")
         } catch {
         print("Error saving drawing as PNG: \(error)")
         }}
         */
        
        
        
        
        
        let backgroundImage = sketch
        let drawing = canvasView.drawing
        
        // Get the size of the canvas
        let canvasSize = canvasView.bounds.size
        
        // Calculate the scale factor for the drawing
        let scaleFactor = min(canvasSize.width / sketch.size.width, canvasSize.height / sketch.size.height)
        
        // Calculate the size of the drawing in the canvas coordinate system
        let drawingSize = CGSize(width: sketch.size.width * scaleFactor, height: sketch.size.height * scaleFactor)
        
        // Calculate the position of the drawing in the canvas coordinate system
        let drawingOrigin = CGPoint(x: (canvasSize.width - drawingSize.width) / 2, y: (canvasSize.height - drawingSize.height) / 2)
        
        // Create a drawing context with the canvas size
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        
        // Draw the background image
        backgroundImage.draw(in: CGRect(origin: .zero, size: canvasSize))
        
        // Draw the drawing image centered on the canvas
        drawing.image(from: CGRect(origin: drawingOrigin, size: drawingSize), scale: 1.0).draw(at: drawingOrigin)
        
        // Get the merged image from the context
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        if let mergedImage = mergedImage {
        toShare.append(mergedImage)
        }
        
        toShare.append(backgroundImage)
        toShare.append(drawing.image(from: drawing.bounds, scale: 1.0))
        
        guard let mergedImage = mergedImage else {
            print("Failed to create merged image")
            return
        }
        
        // Convert the UIImage to PNG data
        guard let pngData = mergedImage.pngData() else {
            print("Failed to convert image to PNG data")
            return
        }
        
        // Save the PNG data to a file
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("drawing.png")
        
        do {
            try pngData.write(to: fileURL)
            print("Drawing saved as PNG at: \(fileURL)")
        } catch {
            print("Error saving drawing as PNG: \(error)")
        }}
    
}

struct CanvasRepresentable: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var selectedTool: PKInkingTool?
    
    let toolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.delegate = context.coordinator
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if let tool = selectedTool {
            uiView.tool = tool
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasRepresentable
        
        init(_ parent: CanvasRepresentable) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Optional: Handle drawing changes
        }
    }
}

struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDrawing: Bool
    @State var pencilType: PKInkingTool.InkType
    @State var color: Color
    let drawingFrame = CGRect(x: 0, y: 0, width: 512, height: 512) // Define the frame for drawing

    let drawing = PKDrawing()
    var ink: PKInkingTool{
        PKInkingTool(pencilType, color: UIColor(color))
    }
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) ->  PKCanvasView {
        canvas.drawingPolicy = .anyInput
        //Eraser Tool
        //canvas.tool = isDrawing ? ink : eraser
        canvas.alwaysBounceVertical = true
        canvas.frame = drawingFrame
        
        //toolPicker //ovviamente non funge
        let toolPicker  = PKToolPicker.init()
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas) //notify when the picker configuration changes
        canvas.becomeFirstResponder()
        
        return canvas
    } //makeUIView
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDrawing ? ink : eraser
    } // updateUIView
    
    

}
