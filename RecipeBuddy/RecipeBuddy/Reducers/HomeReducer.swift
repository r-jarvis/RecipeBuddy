//
//  HomeReducer.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import Dependencies
import Foundation
import ComposableArchitecture
import SwiftUI
import CoreData

struct Home: ReducerProtocol {
    struct State: Equatable {
        var searchValue: String = ""
        var recipes: [Recipe] = []
        var path: [Route] = []
        var selectedRecipe: RecipeDetails? = nil
        var showRecipeFavoriteAlert: Bool = false
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        var recipeSearchError: Bool = false
        
        enum Route: Hashable {
            case recipeList
            case recipe
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case searchFieldChanged(String)
        case search
        case apiClient(TaskResult<Bool>)
        case pathChanged([State.Route])
        case selectRecipe(Recipe)
        case goBackFromRecipe
        case goBackFromRecipeList
        case createPDF(URL)
        case alertDismissed
        case recipe(RecipeReducer.Action)
        
        // API responses
        case searchResponse(TaskResult<RecipeSearchResults>)
        case recipeResponse(TaskResult<RecipeDetails>)
    }
    
    @Dependency(\.apiClient) var apiClient
    private enum ApiId {}
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case let .searchFieldChanged(search):
                state.searchValue = search
                return .none
                
            case .search:
                state.recipeSearchError = false
                if state.searchValue.isEmpty {
                    if let value = UserDefaults.standard.value(forKey: "offset") as? Int {
                        UserDefaults.standard.setValue(value + 10, forKey: "offset")
                    } else {
                        UserDefaults.standard.setValue(0, forKey: "offset")
                    }
                    return .task { [searchValue = state.searchValue] in
                        await .searchResponse(TaskResult { try await self.apiClient.search(searchValue, UserDefaults.standard.value(forKey: "offset") as? Int ?? 0) })
                    }
                }
                
                return .task { [searchValue = state.searchValue] in
                    await .searchResponse(TaskResult { try await self.apiClient.search(searchValue, 0) })
                }
                
            case .searchResponse(.failure):
                // TODO: Add in failure logic
                return .none
                
            case .recipeResponse(.failure):
                state.recipeSearchError = true
                return .none
                
            case let .searchResponse(.success(response)):
                state.recipes = response.results
                state.path.append(.recipeList)
                return .none
                
            case .apiClient:
                return .none
                
            case let .pathChanged(newPath):
                state.selectedRecipe = nil
                state.path = newPath
                return .none
                
            case let .selectRecipe(recipe):
                state.path.append(.recipe)
                
                return .task { [recipeId = recipe.id] in
                    await .recipeResponse(TaskResult { try await self.apiClient.getRecipeById(recipeId) })
                }
                
            case let .recipeResponse(.success(recipe)):
                state.selectedRecipe = recipe
                return .none
                
            case .goBackFromRecipe:
                if !state.path.isEmpty {
                    state.path.removeLast()
                }
                
                return .none
                
            case let .createPDF(url):
                print("URL: \(url)")
                return .none
                
            case .recipe(.favorite):
                guard let recipe = state.selectedRecipe else { return .none }
                
                let coreDataStack: CoreDataStack = .init(modelName: "RecipeBuddy")
                let newFavorite = Favorite(context: coreDataStack.managedContext)
                newFavorite.id = Int64(recipe.id)
                newFavorite.image = recipe.image ?? ""
                newFavorite.title = recipe.title ?? "Recipe Name"
                coreDataStack.saveContext()
                state.showRecipeFavoriteAlert = true
                
                return .none
                
            case .alertDismissed:
                state.showRecipeFavoriteAlert = false
                return .none
                
            case .goBackFromRecipeList:
                state.path = []
                return .none
                
            case .recipe:
                return .none
            }
        }
        .ifLet(\.recipe, action: /Action.recipe) {
            RecipeReducer()
        }
    }
}
