//
//  ActorsScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 18/12/2024.
//

import SwiftUI

class MyDataManager {
    
    static let instance = MyDataManager()
    private init() {}
    
    var data: [String] = []
    
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current.isMainThread)
            completionHandler(self.data.randomElement())
        }
    }
    
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() {}
    
    var data: [String] = []
    
    nonisolated let myRandomText = "just random text"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current.isMainThread)
        return data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "new Data"
    }
}

struct HomeView: View {
    
    let dataManager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear {
            _ = dataManager.getSavedData()
            _ = dataManager.myRandomText
        }
        .onReceive(timer, perform: {  _ in
            
            Task {
                if let data = await dataManager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .background).async {
//                dataManager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        })
    }
}

struct BrowseView: View {
    
    let dataManager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
            
        }
        .onReceive(timer, perform: {  _ in
            
            Task {
                if let data = await dataManager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .default).async {
//                dataManager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        })
    }
    
}

struct ActorsScreen: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsScreen()
}
