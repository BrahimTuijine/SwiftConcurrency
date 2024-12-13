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
        async let fetchImage4 = fetchImage()
        
        let (image1, image2, image3, image4) = await (try fetchImage1,try fetchImage2,try fetchImage3, try fetchImage4)
        
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        try await withThrowingTaskGroup(of: UIImage.self) { group in
            var images: [UIImage] = []
            
            for _ in (0..<10) {
                group.addTask { try await self.fetchImage() }
            }
            
            for try await image in group {
                images.append(image)
            }
            
            return images
        }
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
    
    func fetchImages() async -> Void {
        let images = try? await manager.fetchImagesWithTaskGroup()
        if let images = images {
            self.images = images
        }
    }
}

struct TaskGroupScreen: View {
    
    @StateObject private var vm = TaskGroupViewModel()
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
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
            .task {
                await vm.fetchImages()
        }
        }
    }
}

#Preview {
    TaskGroupScreen()
}
