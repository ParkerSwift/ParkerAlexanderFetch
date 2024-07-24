//
//  DesertListView.swift
//  Fetch
//
//  Created by Parker Joseph Alexander on 7/23/24.
//

import SwiftUI

struct DessertListView: View {
    @ObservedObject private var viewModel = MealViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.desserts.sorted(by: { $0.name < $1.name })) { dessert in
                NavigationLink(destination: MealDetailView(mealId: dessert.id)) {
                    DessertRowView(dessert: dessert)
                }
            }
        }
        .navigationTitle("Desserts")
        .overlay(Group {
            if viewModel.isLoading {
                ProgressView()
            }
        })
        .alert("Error", isPresented: Binding.constant(viewModel.errorMessage != nil), actions: {
            Button("OK") {}
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
        .onAppear {
            viewModel.fetchDesserts()
        }
    }
}

struct DessertRowView: View {
    let dessert: Meal
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: dessert.thumbnailURL ?? "No Image")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            Text(dessert.name)
                .font(.headline)
        }
    }
}

#Preview {
    NavigationView {
        DessertListView()
    }
}
