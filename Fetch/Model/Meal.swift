//
//  MealView.swift
//  Fetch
//
//  Created by Parker Joseph Alexander on 7/23/24.
//

import SwiftUI

struct MealResponse: Codable {
    let meals: [Meal]?
}

struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let thumbnailURL: String?
    let instructions: String?
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
        case instructions = "strInstructions"
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        
        // Custom initializer that returns an optional
        init?(stringValue: String) {
            switch stringValue {
            case "idMeal": self = .id
            case "strMeal": self = .name
            case "strMealThumb": self = .thumbnailURL
            case "strInstructions": self = .instructions
            default:
                if stringValue.starts(with: "strIngredient") || stringValue.starts(with: "strMeasure") {
                    self.init(rawValue: stringValue)
                } else {
                    return nil
                }
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        
        // Decode ingredients
        var ingredients: [Ingredient] = []
        let allKeys = container.allKeys
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            if allKeys.contains(where: { $0.stringValue == ingredientKey }),
               let ingredientCodingKey = CodingKeys(stringValue: ingredientKey),
               let measureCodingKey = CodingKeys(stringValue: measureKey),
               let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientCodingKey),
               let measure = try container.decodeIfPresent(String.self, forKey: measureCodingKey),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ingredients.append(Ingredient(name: ingredient, measure: measure))
                print("Added ingredient: \(ingredient), measure: \(measure)")
            }
        }
        self.ingredients = ingredients
        print("Total ingredients: \(ingredients.count)")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(thumbnailURL, forKey: .thumbnailURL)
        try container.encodeIfPresent(instructions, forKey: .instructions)
        
        for (index, ingredient) in ingredients.enumerated() {
            if let ingredientKey = CodingKeys(stringValue: "strIngredient\(index + 1)"),
               let measureKey = CodingKeys(stringValue: "strMeasure\(index + 1)") {
                try container.encode(ingredient.name, forKey: ingredientKey)
                try container.encode(ingredient.measure, forKey: measureKey)
            }
        }
        
        // Encode empty strings for unused ingredient/measure fields
        for i in (ingredients.count + 1)...20 {
            if let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)"),
               let measureKey = CodingKeys(stringValue: "strMeasure\(i)") {
                try container.encode("", forKey: ingredientKey)
                try container.encode("", forKey: measureKey)
            }
        }
    }
}

struct Ingredient: Identifiable, Codable {
    let id: UUID
    let name: String
    let measure: String

    enum CodingKeys: String, CodingKey {
        case name, measure
    }

    init(id: UUID = UUID(), name: String, measure: String) {
        self.id = id
        self.name = name
        self.measure = measure
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        measure = try container.decode(String.self, forKey: .measure)
        id = UUID()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(measure, forKey: .measure)
    }
}

