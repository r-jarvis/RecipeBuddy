//
//  apiClient.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/13/23.
//

import Dependencies
import Foundation

/// Client that is used to make all spoonacular api calls
/// Can be initialized multiple times across different reducers
struct ApiClient {
    var search: @Sendable (String, Int) async throws -> RecipeSearchResults
    var getRecipeById: @Sendable (Int) async throws -> RecipeDetails
}

/// Live value that runs all API calls and returns a TaskResult
extension ApiClient: DependencyKey {
    static let liveValue = ApiClient(
        /// Pass a query String used in the search for new recipes. If query is blank, use offset to return 10 new recipes t from the API
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
        /// Pass a recipeID and return either an error or a RecipeDetails object for that ID
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

/// Simple extention that is used in testing to simulate API calls
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

/// Wrapper to access and update the apiClient
extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
