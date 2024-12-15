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

struct MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

extension StructClassActorScreen {
    
    private func runTest() {
        print("test started")
//        structTest1()
//        print("""
//
//        -----------------------------------
//
//        """)
//        classTest1()
        structTest2()
    }
    
    
    private func structTest1() -> Void {
        let objectA = MyStruct(title: "starting title")
        print("objectA :", objectA.title)
        // pass by value
        var objectB = objectA
        print("objectB :", objectB.title)
        
        objectB.title = "Second title!"
        print ("ObjectA:", objectA.title)
        print ("ObjectB:", objectB.title)
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "starting title")
        print("objectA :", objectA.title)
        // pass by reference
        var objectB = objectA
        print("objectB :", objectB.title)
        
        objectB.title = "Second title!"
        print ("ObjectA:", objectA.title)
        print ("ObjectB:", objectB.title)
    }
    
    
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(title: String) -> CustomStruct {
        CustomStruct(title: title)
    }
}

extension StructClassActorScreen {
    private func structTest2() {
        print("struct test 2")
        var struct1 = MyStruct(title: "title 1")
        print("struct1 :", struct1.title)
        struct1.title = "new title"
        print("struct1 :", struct1.title)
        
        var struct2 = CustomStruct(title: "title 1")
        print("struct2 :", struct2.title)
        struct2 = CustomStruct(title: "title 2")
        print("struct2 :", struct2.title)
        var struct3 = CustomStruct(title: "title 2")
        print("struct2 :", struct3.title)
        struct3 = struct3.updateTitle(title: "title 3")
        print("struct3 :", struct3.title)
    }
}


#Preview {
    StructClassActorScreen()
}
