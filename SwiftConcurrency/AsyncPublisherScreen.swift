//
//  AsyncPublisherScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 21/12/2024.
//

import SwiftUI

actor AsyncPublisherDataManager {
    
    @Published var data: [String] = []
    
    func addData() async {
        data.append("apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("watermelon")
    }
}

class AsyncPublisherViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    init()  {
         addSubscribers()
    }
    
    func addSubscribers() -> Void {
        
        Task {
            for await value in await manager.$data.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
        
//        Task {
//            for await value in manager.$data.values {
//                await MainActor.run {
//                    self.dataArray = value
//                }
//            }
//        }
        
        //        manager.$data.sink { data in
        //            self.dataArray = data
        //        }
        //        .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherScreen: View {
    
    @StateObject private var vm = AsyncPublisherViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(vm.dataArray, id: \.self) {
                Text($0)
                    .font(.headline)
            }
        }
        .task {
            await vm.start()
        }
    }
}

#Preview {
    AsyncPublisherScreen()
}
