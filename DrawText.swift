import SwiftUI
import UIKit
import PencilKit

class DrawingView: UIView {
    let canvasView = PKCanvasView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCanvasView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCanvasView()
    }

    private func setupCanvasView() {
        addSubview(canvasView)
        canvasView.frame = bounds
        canvasView.backgroundColor = .clear
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 10)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        canvasView.frame = bounds
    }
    func saveDrawing() -> Data? {
        return canvasView.drawing.dataRepresentation()
    }

    func loadDrawing(from data: Data) {
        if let drawing = try? PKDrawing(data: data) {
            canvasView.drawing = drawing
        }
    }
}

struct DrawingViewWrapper: UIViewRepresentable {
    typealias UIViewType = DrawingView

    func makeUIView(context: Context) -> DrawingView {
        return DrawingView()
    }

    func updateUIView(_ uiView: DrawingView, context: Context) {
        // Update the UIView if needed
    }
}
