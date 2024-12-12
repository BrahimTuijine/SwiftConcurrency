//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrency
//
//  Created by MacBook on 12/12/2024.
//

import SwiftUI

class AsyncViewViewModel: ObservableObject {
    @Published var items: [String] = []
    
    func addItem() -> () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.items.append("title1: \(Thread.current)")
        }
    }
    
    func addItem2() -> () {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.items.append(title)
            }
        }
    }
    
    func addAuthor() async -> Void {
        
        let author1 = "Author1: \(Thread.current)"
        await MainActor.run {
            self.items.append(author1)
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2: \(Thread.current)"
       
        await MainActor.run {
            self.items.append(author2)
            
            let author3 = "Author2: \(Thread.current)"
            self.items.append(author3)
        }
    }
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject private var vm = AsyncViewViewModel()
    
    var body: some View {
        List {
            ForEach(vm.items, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            vm.addItem()
//            vm.addItem2()
            Task {
                await vm.addAuthor()
            }
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
