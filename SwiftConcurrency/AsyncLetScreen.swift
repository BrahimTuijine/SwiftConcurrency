//
//  AsyncLetScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 13/12/2024.
//

import SwiftUI

struct AsyncLetScreen: View {
    
    @State private var images: [UIImage] = []
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async let 🥳")
            .task {
                
                async let fetchImage1: Void = fetchImage()
                async let fetchImage2: Void = fetchImage()
                async let fetchImage3: Void = fetchImage()
                async let fetchImage4: Void = fetchImage()
                
                await (try? fetchImage1,try? fetchImage2,try? fetchImage3, try? fetchImage4)
   
            }
        }
    }
}

extension AsyncLetScreen {
    func fetchImage() async throws -> Void {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            await MainActor.run {
                if let image = image {
                    self.images.append(image)
                }
            }
            
        } catch  {
            throw error
        }
    }
}


#Preview {
    AsyncLetScreen()
}
