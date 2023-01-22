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
    
    
    func analyzeImage(_ image: UIImage?) {
        guard let resized = image?.resize(size: CGSize(width: 224, height: 224)) else { return }
        guard let buffer = resized.getCVPixelBuffer() else { return }
        
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
}
