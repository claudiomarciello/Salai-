import SwiftUI
import PencilKit
import UIKit
import SwiftData


struct CanvaView: View {

    @State private var canvas = PKCanvasView()
    @State private var isDrawing = true
    @State private var color: Color = .black
    @State private var pencilType: PKInkingTool.InkType = .pencil
    @State private var colorPicker = false

    var body: some View {
        VStack {
            ZStack{
                Image("PresetStyle1")
                    .overlay(
                        DrawingView(canvas: $canvas, isDrawing: $isDrawing, pencilType: pencilType, color: color).opacity(0.7)
)
                
                
            }
            Button("Save Drawing") {
                self.saveDrawing() // Call saveDrawing from CanvaView
            }
            Button("Load Drawing") {
                self.loadDrawing() // Call loadDrawing from CanvaView
            }
            Button("Png"){
                self.saveDrawingAsPNG()
            }
        }
    }

    // Move saveDrawing and loadDrawing methods here
    func saveDrawing() {
        // Get the drawing from the canvas
        let drawing = canvas.drawing
        
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
            canvas.drawing = drawing
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
    
    func saveDrawingAsPNG() {
        // Get the drawing from the canvas
        let drawing = canvas.drawing
        
        // Create a UIImage from the drawing
        let drawingImage = drawing.image(from: CGRect(origin: .zero, size: CGSize(width: 1024, height: 1024)), scale: 1)
        saveImageAsPNG(image: drawingImage, filename: "image1")
        // Load the background image
        guard let backgroundImage = UIImage(named: "PresetStyle1") else {
            print("Error: Failed to load background image.")
            return
        }
        saveImageAsPNG(image: backgroundImage, filename: "image2")
        
        // Calculate the size of the resulting image
        let width = backgroundImage.size.width
        let height = backgroundImage.size.height
        let size = CGSize(width: width, height: height)
        
        // Create a drawing context with the calculated size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Draw the background image
        backgroundImage.draw(in: CGRect(origin: .zero, size: size))
        
        // Calculate the offset to center the drawing image
        let xOffset = (width - drawingImage.size.width) / 2
        let yOffset = (height - drawingImage.size.height) / 2
        
        // Draw the drawing image centered on the background image
        drawingImage.draw(in: CGRect(x: 0, y: 0, width: 1024, height: 1024))
        
        // Get the merged image from the context
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        
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
        }
        
        
    }
    

    
    func mergeImages(image1: UIImage, image2: UIImage) -> UIImage? {
        // Get the size of the resulting image
        let size = CGSize(width: image1.size.width,
                         height: image2.size.height)

        
        // Create a drawing context
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Draw the first image
        image1.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
        saveImageAsPNG(image: image1, filename: "image1.png")

        // Draw the second image on top of the first
        image2.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
        saveImageAsPNG(image: image2, filename: "image2.png")

        
        // Get the merged image from the context
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        
        return mergedImage
    }

}

struct CanvaView_Previews: PreviewProvider {
    static var previews: some View {
        CanvaView()
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
