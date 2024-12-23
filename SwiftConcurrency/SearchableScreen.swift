//
//  SearchableScreen.swift
//  SwiftConcurrency
//
//  Created by MacBook on 23/12/2024.
//

import SwiftUI

enum CuisineOptions {
    case tunisian, italien, japanese
}

struct Restaurant: Identifiable, Hashable {
    let id: Int
    let title: String
    let cuisine: CuisineOptions
}

final class RestaurantManager {
    func getAllRestaurants() async throws -> [Restaurant] {
        [
            Restaurant(id: 1, title: "Tunisian Delight", cuisine: .tunisian),
            Restaurant(id: 2, title: "Mama Italia", cuisine: .italien),
            Restaurant(id: 3, title: "Sushi World", cuisine: .japanese),
            Restaurant(id: 4, title: "Mediterranean Feast", cuisine: .tunisian),
            Restaurant(id: 5, title: "Pasta Paradise", cuisine: .italien),
            Restaurant(id: 6, title: "Tokyo Bites", cuisine: .japanese)
        ]
    }
}

@MainActor
final class SearchableVieModel: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = []
    let restaurantManager = RestaurantManager()
    
    func loadRestaurants() async -> Void {
        do {
            self.restaurants = try await restaurantManager.getAllRestaurants()
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct SearchableScreen: View {
    
    @StateObject private var vm = SearchableVieModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.restaurants, id: \.id) { data in
                    restaurantRow(restaurant: data)
                }
                
            }
            .navigationTitle("Restaurants")
            .task {
                await vm.loadRestaurants()
            }
        }
    }
    
    func restaurantRow(restaurant: Restaurant) -> some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(restaurant.title)
                .font(.headline)
            Text("\(restaurant.cuisine)")
                .font(.caption)
            
        }
    }
}

#Preview {
    SearchableScreen()
}


