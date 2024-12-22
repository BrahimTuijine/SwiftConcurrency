//
//  StrongSelfScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 22/12/2024.
//

import SwiftUI

final class StrongSelfDataService {
    func getData() async -> String {
        "Updated Data"
    }
}

final class StrongSelfViewModel: ObservableObject {
    
    @MainActor @Published var data: String = "some title !"
    
    private let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>?
    
    func cancelTask() {
        someTask?.cancel()
        someTask = nil
    }
    
    // this implies a strong reference
    func updateData() {
        Task {
            let data = await dataService.getData()
            
            await MainActor.run {
                self.data = data
            }
        }
    }
    // this is a strong reference
    func updateData2()  {
        Task {
            let data = await dataService.getData()
            
            await MainActor.run {
                self.data = data
            }
        }
    }
    // this is a strong reference
    func updateData3()  {
        Task { [self] in
            let data = await dataService.getData()
            
            await MainActor.run {
                self.data = data
            }
        }
    }
    
    // We dont neet to manage weak/strong
    // We can manage the Task !
    func updateData4() {
        someTask = Task {
            let data = await self.dataService.getData()
            await MainActor.run {
                self.data = data
            }
        }
    }
    
    // We can manage the Task !
    func updateData5() {
        Task.detached {
            let data = await self.dataService.getData()
            await MainActor.run {
                self.data = data
            }
        }
    }
    
}

struct StrongSelfScreen: View {
    
    @StateObject private var vm = StrongSelfViewModel()
    
    var body: some View {
        VStack {
            Text(vm.data)
        }
        .onAppear {
            vm.updateData()
        }
        .onDisappear {
            vm.cancelTask()
        }
            
    }
}

#Preview {
    StrongSelfScreen()
}
