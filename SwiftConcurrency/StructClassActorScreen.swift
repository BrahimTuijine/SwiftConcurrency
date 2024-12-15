//
//  StructClassActorScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 15/12/2024.
//

import SwiftUI

struct StructClassActorScreen: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                runTest()
            }
    }
}

struct MyStruct {
    var title: String
}

extension StructClassActorScreen {
    
    private func runTest() {
        print("test started")
        structTest1()
    }
    
    private func structTest1() -> Void {
        let objectA = MyStruct(title: "starting title")
        print("objectA :", objectA.title)
        var objectB = objectA
        print("objectB :", objectB.title)
        
        objectB.title = "Second title!"
        print ("ObjectA:", objectA.title)
        print ("ObjectB:", objectB.title)
    }
    
    
}

#Preview {
    StructClassActorScreen()
}
