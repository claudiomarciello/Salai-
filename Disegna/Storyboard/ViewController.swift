//
//  ViewController.swift
//  ss
//
//  Created by LorenzoSpinosa on 25/02/24.
//
import PencilKit
import UIKit

class ViewController: UIViewController {

    // il nostro canvas
    private let CanvasView: PKCanvasView = {
        let canvas = PKCanvasView()
        
        //per usare le dita come input
        canvas.drawingPolicy = .anyInput
        return canvas
    }()
    
    let drawing = PKDrawing()
    override func viewDidLoad() {
        super.viewDidLoad()
        CanvasView.drawing = drawing // per renderizzare l'immagine
         view.addSubview(CanvasView)
   }
    
    //sovrapponiamo i frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CanvasView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //per i tool
        let toolPicker  = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: CanvasView)
        toolPicker.addObserver(CanvasView)
        CanvasView.becomeFirstResponder()
    }

}


