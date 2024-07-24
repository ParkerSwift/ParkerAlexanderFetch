//
//  MealDetailView.swift
//  Fetch
//
//  Created by Parker Joseph Alexander on 7/23/24.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject private var viewModel = MealViewModel()
    @State private var searchText = ""
    @State private var showingDessertList = false
    let mealId: String?
    
    init(mealId: String? = nil) {
        self.mealId = mealId
    }
    
    var body: some View {
        VStack {
            if mealId == nil {
                SearchBar(text: $searchText) {
                    viewModel.fetchMeal(id: searchText)
                }
                .padding()
            }
            
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if let meal = viewModel.meal {
                    MealDetailContent(meal: meal)
                } else if mealId == nil {
                    Text("Enter a meal ID and tap search to view details")
                }
            }
        }
        .navigationTitle("Meal Details")
        .onAppear {
            if let id = mealId {
                viewModel.fetchMeal(id: id)
            }
        }
        .sheet(isPresented: $showingDessertList) {
            DessertListView()
        }
    }
}

struct MealDetailContent: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(meal.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let thumbnailURL = meal.thumbnailURL,
               let url = URL(string: thumbnailURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                .cornerRadius(10)
            }
            
            if let instructions = meal.instructions {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(instructions)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)
                ForEach(meal.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text(ingredient.measure)
                    }
                }
            }
        }
        .padding()
    }
}
struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter meal ID", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                
                Button(action: onCommit) {
                    Image(systemName: "magnifyingglass")
                }
            }
            .padding()
            
            if isFocused {
                HStack {
                    Spacer()
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button("Dismiss Keypad") {
                                    isFocused = false
                                }
                            }
                    }
                    .padding(.trailing)
                }
                .background(Color(UIColor.systemBackground))
            }
        }
        .animation(.default, value: isFocused)
    }
}

#Preview {
    NavigationView {
        MealDetailView(mealId: "52768")
    }
}
