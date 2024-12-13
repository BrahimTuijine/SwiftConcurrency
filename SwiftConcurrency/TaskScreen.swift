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
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data , _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                print("image returned Successfully")
                self.image = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async -> Void {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data , _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskScreenHomeView : View {
    var body: some View {
        NavigationStack {
            NavigationLink("Click me !") {
                TaskScreen()
            }
        }
    }
}

struct TaskScreen: View {
    
    @StateObject private var vm = TaskScreenViewModel()
    @State private var fetchImageTask: Task<Void, Never>?
    
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
        .onDisappear{
            fetchImageTask?.cancel()
        }
        .onAppear {
            fetchImageTask = Task {
                await vm.fetchImage()
                
            }
//            Task {
//                await vm.fetchImage2()
//            }
            
//            Task(priority: .userInitiated) {
//                print("userInitiated:  \(Task.currentPriority.rawValue)")
//            }
//            
//            Task(priority: .high) {
//                await Task.yield() 
//                print("high :  \(Task.currentPriority.rawValue)")
//            }
//            
//            Task(priority: .medium) {
//                print ("medium :  \(Task.currentPriority.rawValue)")
//            }
//            
//            Task(priority: .low) {
//                print("low :  \(Task.currentPriority.rawValue)")
//            }
//            
//            Task(priority: .utility) {
//                print("utility:  \(Task.currentPriority.rawValue)")
//            }
//            
//            Task(priority: .background) {
//                print ("background:  \(Task.currentPriority.rawValue)")
//            }
            
            
             
        }
    }
}

#Preview {
    TaskScreen()
}
