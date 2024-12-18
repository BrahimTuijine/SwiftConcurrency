//
//  ActorsScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 18/12/2024.
//

import SwiftUI

struct ActorsScreen: View {
    var body: some View {
        TabView {
            Text("hi")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Text("hi")
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsScreen()
}
