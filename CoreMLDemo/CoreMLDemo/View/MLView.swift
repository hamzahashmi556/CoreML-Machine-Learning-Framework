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
        
        VStack {
            
            Button {
                isPresentPicker.toggle()
            } label: {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .aspectRatio(contentMode: .fit)
                        .imageScale(/*@START_MENU_TOKEN@*/.small/*@END_MENU_TOKEN@*/)
                }
                else {
                    Color.white.opacity(0.1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                }
                    
            }
//            .frame(width: 350, height: 350)
            .background {
                Text("Select Image")
                Color.white.opacity(0.1)
            }
            .onChange(of: selectedImage) { newValue in
                viewModel.analyzeImage(selectedImage)
            }
            
            Text(viewModel.text)

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

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

