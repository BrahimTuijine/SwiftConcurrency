//
//  SendableScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 20/12/2024.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDataBase(userInfo: UserInfo) -> Void {
        
    }
}

struct UserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    
    var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) -> Void {
        queue.async {
            self.name = name
        }
    }
}

class SendableScreenViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async -> Void {
        
        let info = UserInfo(name: "user info")
        
        await manager.updateDataBase(userInfo: info)
    }
}

struct SendableScreen: View {
    
    @StateObject private var vm = SendableScreenViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await vm.updateCurrentUserInfo()
            }
    }
}

#Preview {
    SendableScreen()
}
