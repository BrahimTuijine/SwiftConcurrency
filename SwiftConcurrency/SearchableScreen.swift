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
    let restaurantManager = RestaurantManager()
    @Published private(set) var restaurants: [Restaurant] = []
    @Published private(set) var filtredRestaurants: [Restaurant] = []
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                filtredRestaurants = restaurants
            } else {
                filtredRestaurants = restaurants.filter({
                    $0.title.lowercased().contains(searchText.lowercased()) ||
                    "\($0.cuisine)".lowercased().contains(searchText.lowercased())
                })
            }
        }
    }
    
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
                ForEach(vm.searchText.isEmpty ?
                        vm.restaurants :
                            vm.filtredRestaurants,
                        id: \.id) { data in
                    restaurantRow(restaurant: data)
                }
                //                    SearchChildView()
            }
            .searchable(
                text: $vm.searchText,
                placement: .automatic,
                prompt: Text("search restaurant")
            )
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

struct SearchChildView: View {
    
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        Text("Child View is searching: \(isSearching)")
    }
}

#Preview {
    SearchableScreen()
}


