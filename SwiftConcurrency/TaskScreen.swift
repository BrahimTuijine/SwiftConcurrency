//
//  TaskScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 12/12/2024.
//

import SwiftUI

class TaskScreenViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var image2: UIImage?
    
    func fetchImage() async -> Void {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data , response) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async -> Void {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data , response) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskScreen: View {
    
    @StateObject private var vm = TaskScreenViewModel()
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
            } else {
              ProgressView()
            }
            if let image = vm.image2 {
                Image(uiImage: image)
            } else {
              ProgressView()
            }
        }
        .onAppear {
            Task {
                await vm.fetchImage()
                
            }
            Task {
                await vm.fetchImage2()
            }
        }
    }
}

#Preview {
    TaskScreen()
}
