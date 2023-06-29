//
//  apiClient.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/13/23.
//

import Dependencies
import Foundation

struct ApiClient {
    var search: @Sendable (String, Int) async throws -> RecipeSearchResults
    var getRecipeById: @Sendable (Int) async throws -> RecipeDetails
}

extension ApiClient: DependencyKey {
    static let liveValue = ApiClient(
        search: { query, offset in
            var components = URLComponents(string: "https://api.spoonacular.com/recipes/complexSearch")!
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: Bundle.main.infoDictionary?["SPOON_API_KEY"] as? String),
                URLQueryItem(name: "query", value: query)
            ]
            
            /// Apply recipe settings
            if let diet = DietOptions(rawValue: UserDefaults.standard.object(forKey: "diet") as? String ?? "all"), diet != .all {
                components.queryItems?.append(URLQueryItem(name: "diet", value: diet.description))
            }
            
            if let allergies = AllergyOptions(rawValue: UserDefaults.standard.object(forKey: "allergies") as? String ?? "all"), allergies != .none {
                components.queryItems?.append(URLQueryItem(name: "allergies", value: allergies.description))
            }
            
            if let recipeType = RecipeTypeOptions(rawValue: UserDefaults.standard.object(forKey: "recipeType") as? String ?? "all"), recipeType != .all {
                components.queryItems?.append(URLQueryItem(name: "recipeType", value: recipeType.description))
            }
            
            if let cuisine = CuisineOptions(rawValue: UserDefaults.standard.object(forKey: "cuisine") as? String ?? "all"), cuisine != .all {
                components.queryItems?.append(URLQueryItem(name: "cuisine", value: cuisine.description))
            }
            
            /// Only itterate the offset if there is a blank input query
            if query.isEmpty {
                components.queryItems?.append(URLQueryItem(name: "offset", value: String(offset)))
            }
            
            /// Get data result from URL
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            
            /// Decode to local 'RecipeSearchResults' struct
            return try JSONDecoder().decode(RecipeSearchResults.self, from: data)
        },
        getRecipeById: { recipeId in
            var components = URLComponents(string: "https://api.spoonacular.com/recipes/\(recipeId)/information")!
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: Bundle.main.infoDictionary?["SPOON_API_KEY"] as? String)
            ]

            /// Get data result from URL
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            
            /// Decode to local 'RecipeDetails' struct
            return try JSONDecoder().decode(RecipeDetails.self, from: data)
        }
    )
}

extension ApiClient: TestDependencyKey {
    static let previewValue = Self(
        search: { _ , _ in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 5)
            return RecipeSearchResults() 
        },
        getRecipeById: { _ in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 5)
            return RecipeDetails(id: 123, summary: "summary")
        }
    )

    static let testValue = Self(
        search: unimplemented("\(Self.self).search"),
        getRecipeById: unimplemented("\(Self.self).getRecipeById")
    )
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
