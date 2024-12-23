//
//  MVVMScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 23/12/2024.
//

import SwiftUI

class MyManagerClass {
    func getData() async throws -> String {
        "get Data !"
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        "get Data !"
    }
}

@MainActor
final class MVVMViewModel: ObservableObject {
    private let managetClass = MyManagerClass()
    private let managetActor = MyManagerActor()
    private var tasks: [Task<Void, Never>] = []
    @Published private(set) var myData = "Starting text"

    
    private func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func onCallButtonActionPressed() -> Void {
        let task = Task {
            do {
//                self.myData = try await managetClass.getData()
                self.myData = try await managetActor.getData()
            } catch {
                print(error.localizedDescription)
            }
        }
        self.tasks.append(task)
    }
    
}

struct MVVMScreen: View {
    
    @StateObject private var vm = MVVMViewModel()
    
    var body: some View {
        Text(vm.myData)
            .font(.headline)
        
        Button("Click me") {
            vm.onCallButtonActionPressed()
        }
    }
}

#Preview {
    MVVMScreen()
}
