//
//  ContentView.swift
//  SwiftConcurrency
//
//  Created by MacBook on 11/12/2024.
//

import SwiftUI

class DoTryCatchDataManager {
    
    let isActive: Bool = true
    
    func getText() -> (title: String?, error: Error?) {
        if isActive {
            return ("new Title", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getText2() -> Result<String, Error> {
        if isActive {
            return .success("new title")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getText3() throws -> String {
        if isActive {
            return "new title"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}



class DoTryCatchViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    
    let dataManager = DoTryCatchDataManager()
    
    func fetchText() -> Void {
        //        let newValue = dataManager.getText()
        //        if let newText = newValue.title  {
        //            text = newText
        //        } else {
        //            text = newValue.error!.localizedDescription
        //        }
        
        //let result = dataManager.getText2()
//        switch result {
//        case .success(let newData):
//            text = newData
//        case .failure(let error):
//            text = error.localizedDescription
//        }
    
//        do {
            let result = try? dataManager.getText3()
            text = result ?? ""
//        } catch {
//            text = error.localizedDescription
//        }
        
    }
}

struct DoTryCatch: View {
    @StateObject private var vm = DoTryCatchViewModel()
    
    var body: some View {
        VStack {
            
            Text(vm.text)
                .frame(width: 300, height: 300)
                .background(Color.blue )
                .onTapGesture {
                    vm.fetchText()
                }
            
        }
        .padding()
    }
}

#Preview {
    DoTryCatch()
}
