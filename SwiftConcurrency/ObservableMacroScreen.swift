//
//  ObservableMacroScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 25/12/2024.
//

import SwiftUI

actor TitleDataBase {
    func getTitle() -> String {
        "title from db"
    }
}

@Observable class ObservableMacroViewModel {
    @MainActor var title: String = "starting text !"
    @ObservationIgnored let db = TitleDataBase()
    
    @MainActor
    func updateTitle() -> Void {
        Task { @MainActor in
            title = await db.getTitle()
        }
    }
}

struct ObservableMacroScreen: View {
    
    @State private var vm = ObservableMacroViewModel()
    
    var body: some View {
        Text(vm.title)
            .onAppear {
                vm.updateTitle()
            }
    }
}

#Preview {
    ObservableMacroScreen()
}
