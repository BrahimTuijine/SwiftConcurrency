//
//  PhotoPickerScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 24/12/2024.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published private(set) var selectedImage: UIImage?
    @Published  var imageSelection: PhotosPickerItem? {
        didSet {
            setImage(selected: imageSelection)
        }
    }
    
    private func setImage(selected: PhotosPickerItem?) -> () {
        guard let image = selected else { return }
        
        Task {
            if let data = try? await image.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
    
}

struct PhotoPickerScreen: View {
    
    @StateObject private var vm = PhotoPickerViewModel()
    
    var body: some View {
        VStack(spacing: 40.0) {
            Text("Hello, World!")
            
            if let image = vm.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(10)
                    .frame(width: 200, height: 200)
            }
            
            PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                Text("open the photo picker")
                    .foregroundColor(Color.red)
            }
            
        }
    }
}

#Preview {
    PhotoPickerScreen()
}
