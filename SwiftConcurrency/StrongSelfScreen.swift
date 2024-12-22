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
    
    // this implies a strong reference
    func updateData() async {
        let data = await dataService.getData()
        
        await MainActor.run {
            self.data = data
        }
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
