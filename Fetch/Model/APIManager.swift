//
//  APIManager.swift
//  Fetch
//
//  Created by Parker Joseph Alexander on 7/23/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURLString = "https://www.themealdb.com/api/json/v1/1/"
    
    private init() {}
    
    func fetchDesserts() async throws -> [Meal] {
        let urlString = baseURLString + "filter.php?c=Dessert"
        let mealResponse: MealResponse = try await performRequest(with: urlString)
        
        guard let meals = mealResponse.meals else {
            throw NSError(domain: "APIError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No desserts found"])
        }
        
        return meals
    }
    
    func fetchMealById(id: String) async throws -> Meal? {
        let urlString = baseURLString + "lookup.php?i=\(id)"
        let mealResponse: MealResponse = try await performRequest(with: urlString)
        
        // Check if meals array is nil or empty
        guard let meals = mealResponse.meals, !meals.isEmpty else {
            print("No meal found with id: \(id)")
            return nil
        }
        
        return meals.first
    }
    
    private func performRequest<T: Decodable>(with urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        print("Raw API response: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
        
        do {
            let decodedResult = try JSONDecoder().decode(T.self, from: data)
            return decodedResult
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}
