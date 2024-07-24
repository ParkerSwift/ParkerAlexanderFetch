//
//  ContentView.swift
//  Fetch
//
//  Created by Parker Joseph Alexander on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink("Search Meal", destination: MealDetailView())
                    .bold()
                    .font(.title)
                Spacer()
                NavigationLink("View Desserts", destination: DessertListView())
                    .bold()
                    .font(.title)
                Spacer()
            }
            .navigationTitle("Meal App")
        }
    }
}

#Preview {
    ContentView()
}
