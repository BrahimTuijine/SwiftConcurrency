//
//  RefreshableSceen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 23/12/2024.
//

import SwiftUI

final class RefreshableDataService {
    func getData() async throws -> [String] {
        
       try? await Task.sleep(nanoseconds: 5_000_000_000)
        
       return ["banana", "apple", "orange"].shuffled()
    }
}

@MainActor
final class RefreshableViewModel: ObservableObject {
    @Published private(set) var data: [String] = []
    private let dataService = RefreshableDataService()
    
    func getData() async -> Void {
        
            do {
                self.data = try await dataService.getData()
            } catch {
                print(error.localizedDescription)
            }
        
    }
}

struct RefreshableScreen: View {
    
    @StateObject private var vm = RefreshableViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.data, id: \.self) {
                        Text($0)
                            .font(.title)
                    }
                }
            }
            .refreshable {
                await vm.getData()
            }
            .task {
                await vm.getData()
            }
            .navigationTitle("Refreshable")
        }
    }
}

#Preview {
    RefreshableScreen()
}
