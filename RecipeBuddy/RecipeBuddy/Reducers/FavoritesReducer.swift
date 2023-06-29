//
//  FavoritesReducer.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/20/23.
//

import Dependencies
import Foundation
import ComposableArchitecture
import SwiftUI
import CoreData


struct Favorites: ReducerProtocol {
    struct State: Equatable {
        var showRecipeFavoriteAlert: Bool = false
        var recipeSearchError: Bool = false
        
        var recipes: [Recipe] = []
        var path: [Route] = []
        var selectedRecipe: RecipeDetails?
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        
        enum Route: Hashable {
            case recipe
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case pathChanged([State.Route])
        case selectRecipe(Recipe)
        case recipe(RecipeReducer.Action)
        case recipeResponse(TaskResult<RecipeDetails>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.recipes = []
                let coreDataStack: CoreDataStack = .init(modelName: "RecipeBuddy")
                let noteFetch: NSFetchRequest<Favorite> = Favorite.fetchRequest()
                
                do {
                    let results = try coreDataStack.managedContext.fetch(noteFetch)
                    for r in results {
                        state.recipes.append(Recipe(id: Int(r.id), title: r.title, image: r.image))
                    }
                } catch let error as NSError {
                    print("Fetch error: \(error) description: \(error.userInfo)")
                }
                
                return .none
                
            case let .pathChanged(newPath):
                state.selectedRecipe = nil
                state.path = newPath
                return .none
                
            case let .selectRecipe(recipe):
                state.recipeSearchError = false
                state.path.append(.recipe)
                return .task { [recipeId = recipe.id] in
                     await .recipeResponse(TaskResult { try await self.apiClient.getRecipeById(recipeId) })
                }
                
            case let .recipeResponse(.success(recipe)):
                state.selectedRecipe = recipe
                return .none
                
            case .recipeResponse(.failure):
                state.recipeSearchError = true
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

extension Favorites.State {
    var recipe: RecipeReducer.State? {
        get {
            RecipeReducer.State(
                selectedRecipe: self.selectedRecipe,
                showRecipeFavoriteAlert: self.showRecipeFavoriteAlert,
                recipeSearchError: self.recipeSearchError
            )
        }
        set {
            self.selectedRecipe = newValue?.selectedRecipe
            self.showRecipeFavoriteAlert = newValue?.showRecipeFavoriteAlert ?? false
            self.recipeSearchError = newValue?.recipeSearchError ?? false
        }
    }
}
