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
            if let diet = UserDefaults.standard.object(forKey: "diet") as? DietOptions, diet != .all {
                components.queryItems?.append(URLQueryItem(name: "diet", value: diet.description))
            }
            
            if let diet = UserDefaults.standard.object(forKey: "allergies") as? DietOptions, diet != .all {
                components.queryItems?.append(URLQueryItem(name: "allergies", value: diet.description))
            }
            
            if let diet = UserDefaults.standard.object(forKey: "recipeType") as? DietOptions, diet != .all {
                components.queryItems?.append(URLQueryItem(name: "recipeType", value: diet.description))
            }
            
            if let diet = UserDefaults.standard.object(forKey: "cuisine") as? DietOptions, diet != .all {
                components.queryItems?.append(URLQueryItem(name: "cuisine", value: diet.description))
            }
            
            /// Only itterate the offset if there are no settings or query input
            if let items = components.queryItems, query.isEmpty, items.count <= 2  {
                components.queryItems?.append(URLQueryItem(name: "offset", value: String(offset)))
            }

            let (data, _) = try await URLSession.shared.data(from: components.url!)
            
            let str = String(data: data, encoding: .utf8)
            return try JSONDecoder().decode(RecipeSearchResults.self, from: data)
        },
        getRecipeById: { recipeId in
            var components = URLComponents(string: "https://api.spoonacular.com/recipes/\(recipeId)/information")!
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: Bundle.main.infoDictionary?["SPOON_API_KEY"] as? String)
            ]

            let (data, _) = try await URLSession.shared.data(from: components.url!)
            
            let str = String(data: data, encoding: .utf8)
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
