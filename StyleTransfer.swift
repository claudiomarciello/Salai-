//
//  StyleTransfer.swift
//  Salaì
//
//  Created by Claudio Marciello on 25/02/24.
//


import CoreML
import CreateML
import Combine

import Foundation
import SwiftUI


// 1
class StyleTransfer{
    
    let dataSource = MLStyleTransfer.DataSource.images(
        styleImage: styleImage,
        contentDirectory: Constants.Path.trainingImagesDir ?? Bundle.main.bundleURL,
        processingOption: nil)
    // 2
    let sessionParams = MLTrainingSessionParameters(
        sessionDirectory: sessionDir,
        reportInterval: Constants.MLSession.reportInterval,
        checkpointInterval: Constants.MLSession.checkpointInterval,
        iterations: Constants.MLSession.iterations)
    // 3
    let modelParams = MLStyleTransfer.ModelParameters(
        algorithm: .cnn,
        validation: .content(validationImage),
        maxIterations: Constants.MLModelParam.maxIterations,
        textelDensity: Constants.MLModelParam.styleDensity,
        styleStrength: Constants.MLModelParam.styleStrength)
}
