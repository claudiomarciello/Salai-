//
//  ViewController.swift
//  ss
//
//  Created by LorenzoSpinosa on 25/02/24.
//
import PencilKit
import UIKit

public class Peppe: UIViewController {

    // il nostro canvas
    let CanvasView: PKCanvasView = {
        let canvas = PKCanvasView()
        
        //per usare le dita come input
        canvas.drawingPolicy = .anyInput
        return canvas
    }()
    
    let drawing = PKDrawing()
    public override func viewDidLoad() {
        super.viewDidLoad()
        CanvasView.drawing = drawing // per renderizzare l'immagine
         view.addSubview(CanvasView)
   }
    
    //sovrapponiamo i frame
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CanvasView.frame = view.bounds
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //per i tool
        let toolPicker  = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: CanvasView)
        toolPicker.addObserver(CanvasView)
        CanvasView.becomeFirstResponder()
    }

}


