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
    
    @Published var data: String = "some title !"
    
    private let dataService = StrongSelfDataService()
    
    func updateData() async {
        self.data = await dataService.getData()
    }
}

struct StrongSelfScreen: View {
    
    @StateObject private var vm = StrongSelfViewModel()
    
    var body: some View {
        VStack {
            Text(vm.data)
        }
        .task {
            await vm.updateData()
        }
            
    }
}

#Preview {
    StrongSelfScreen()
}
