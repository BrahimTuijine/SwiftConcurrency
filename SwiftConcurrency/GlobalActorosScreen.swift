//
//  GlobalActorosScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 20/12/2024.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
    
    static var shared: MyNewDataManager = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getDataFromDb() -> [String] {
        return ["one", "two", "three", "four", "five"]
    }
}

class GlobalActorsViewModel: ObservableObject {
    
   @MainActor @Published var dataArray: [String] = []
    
    let dataManager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor func getData() async -> () {
        let data = await dataManager.getDataFromDb()
        await MainActor.run {
            self.dataArray = data
        }
    }
}

struct GlobalActorsScreen: View {
    
    @StateObject private var vm = GlobalActorsViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
}

#Preview {
    GlobalActorsScreen()
}
