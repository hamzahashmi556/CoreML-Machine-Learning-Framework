//
//  MLView.swift
//  Test
//
//  Created by Hamza Hashmi on 21/01/2023.
//

import SwiftUI

struct MLView: View {
    
    @StateObject var viewModel = MLViewModel()
    
    @State var selectedImage: UIImage? = nil
    
    @State var isPresentPicker = false
        
    var body: some View {
        
        ZStack {
            
            Button {
                self.isPresentPicker.toggle()
            } label: {
                if let image = self.selectedImage {
                    Image(uiImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                else {
                    Color.white.opacity(0.1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                }
                    
            }
            .background {
                Text("Select Image")
                Color.white.opacity(0.1)
            }
            .onChange(of: self.selectedImage) { newValue in
                self.viewModel.analyzeImageWithMyOwnModel(newValue!)
            }
            
            if !viewModel.outputResults.isEmpty {
                VStack {
                    Spacer()
                    VStack {
                        ForEach(viewModel.outputResults) { result in
                            
                            HStack {
                                Text("\(result.name) : \(result.probabilty)%")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(20)
                    .padding(.bottom, 50)
                }
            }
        }
        .sheet(isPresented: $isPresentPicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}

struct MLView_Previews: PreviewProvider {
    static var previews: some View {
        MLView()
    }
}
