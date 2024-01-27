//
//  MLViewModel.swift
//  Test
//
//  Created by Hamza Hashmi on 21/01/2023.
//

import Foundation
import CoreML
import SwiftUI

class MLViewModel: ObservableObject {
    
    @Published var text = "Select Image"
    @Published var selectedImage = UIImage()
    
    @Published var outputResults: [Result] = []
    @Published var errorMessage: String? = .none
    
    
    func analyzeImageWithGoogleLENetPlaces(_ image: UIImage?) {
        guard let resized = image?.resize(size: CGSize(width: 224, height: 224)) else {
            return
        }
        guard let buffer = resized.getCVPixelBuffer() else {
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try GoogLeNetPlaces(configuration: config)
            let input = GoogLeNetPlacesInput(sceneImage: buffer)
            let output = try model.prediction(input: input)
            text = output.sceneLabel
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func analyzeImageWithMyOwnModel(_ image: UIImage) {
        
        guard let buffer = image.getCVPixelBuffer() else {
            self.errorMessage = "Can not Find Image Buffer"
            return
        }
        
        do {
            let config = MLModelConfiguration()
            
            let model = try MyFirstMLModel.init(configuration: config)
            
            let input = MyFirstMLModelInput(image: buffer)
            
            let output = try model.prediction(input: input)
            
            self.outputResults = output.targetProbability.map {
                let probability = $0.value * 100
                return Result(name: $0.key, probabilty: String(format: "%.1f", probability))
            }
        }
        catch {
            self.errorMessage = "Error MLModel: \(error.localizedDescription)"
            print(#function, error.localizedDescription)
        }
    }
}

struct Result: Identifiable {
    var id = UUID().uuidString
    var name: String
    var probabilty: String
}
