//
//  CheckContinuationScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 14/12/2024.
//

import SwiftUI

class CheckContinuationScreenNetworkManager {
    
    func getData() async throws -> Data {
        guard let url = URL(string: "https://picsum.photos/200") else { throw URLError(.badURL) }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch  {
            throw error
        }
    }
    
    
    func getData2() async throws -> Data {
        guard let url = URL(string: "https://picsum.photos/200") else { throw URLError(.badURL) }
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }.resume()
        }
        
        
    }
}

class CheckContinuationScreenViewModel: ObservableObject {
    @Published var image: UIImage?
    let networkManager = CheckContinuationScreenNetworkManager()
    
    func getImage() async -> Void {
        do {
            let data = try await networkManager.getData2()
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch  {
            print(error)
        }
    }
}

struct CheckContinuationScreen: View {
    
    @StateObject private var vm = CheckContinuationScreenViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
            } else {
                ProgressView()
            }
        }
        .task {
            await vm.getImage()
        }
    }
}

#Preview {
    CheckContinuationScreen()
}
