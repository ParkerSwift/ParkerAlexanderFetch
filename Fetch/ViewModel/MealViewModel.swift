//
//  MealViewModel.swift
//  Fetch
//
//  Created by Parker Joseph Alexander on 7/23/24.
//

import Foundation

class MealViewModel: ObservableObject {
    @Published var meal: Meal?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var desserts: [Meal] = []
    
    private let apiManager: APIManager
    
    init(apiManager: APIManager = .shared) {
        self.apiManager = apiManager
    }
    
    func fetchMeal(id: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedMeal = try await apiManager.fetchMealById(id: id)
                DispatchQueue.main.async {
                    self.meal = fetchedMeal
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch meal: \(error.localizedDescription)"
                    self.isLoading = false
                    print("Error fetching meal: \(error)")
                }
            }
        }
    }
    
    func fetchDesserts() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                desserts = try await apiManager.fetchDesserts()
                isLoading = false
            } catch {
                isLoading = false
                if let nsError = error as NSError?, nsError.domain == "APIError" {
                    errorMessage = nsError.localizedDescription
                } else {
                    errorMessage = "Error fetching desserts: \(error.localizedDescription)"
                }
                print("Error details: \(error)")
            }
        }
    }
}
