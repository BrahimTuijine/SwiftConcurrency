//
//  TaskGroupScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 13/12/2024.
//

import SwiftUI

class TaskGroupDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage()
        async let fetchImage2 = fetchImage()
        async let fetchImage3 = fetchImage()
        
        let (image1, image2, image3) = await (try fetchImage1,try fetchImage2,try fetchImage3)
        
        return [image1, image2, image3]
    }
    
    private func fetchImage() async throws -> UIImage {
        guard let url = URL(string: "https://picsum.photos/200") else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            
            if let image = image {
                return image
            } else {
                throw URLError(.badURL)
            }
            
        } catch  {
            throw error
        }
    }
}

class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
}

struct TaskGroupScreen: View {
    
    @StateObject private var vm = TaskGroupViewModel()
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(vm.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
            }
        }
        .navigationTitle("Task Group 🥳")
    }
}

#Preview {
    TaskGroupScreen()
}
