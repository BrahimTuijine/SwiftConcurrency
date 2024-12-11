//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by MacBook on 11/12/2024.
//

import SwiftUI

class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")
    
     func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 &&  response.statusCode < 300
        else {
            return nil
        }
        return image
    }
    
    func downloadImageWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url!)
            return handleResponse(data: data, response: response)
        } catch  {
            throw error
        }
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let imageLoader = DownloadImageAsyncImageLoader()
    
    func fetchImage() async -> () {
        let image = try? await imageLoader.downloadImageWithAsync()
        
        await MainActor.run {
            self.image = image
        }
    }
}

struct DownloadImageAsync: View {
    
    @StateObject private var vm = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    
            }
        }
        .onAppear  {
            Task {
                await vm.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
