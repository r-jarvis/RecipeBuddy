//
//  RecipeReducer.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/26/23.
//


import Dependencies
import Foundation
import ComposableArchitecture

struct RecipeReducer: ReducerProtocol {
    struct State: Equatable {
        /// Passed from higher level state
        var selectedRecipe: RecipeDetails?
        var showRecipeFavoriteAlert: Bool
        var recipeSearchError: Bool
    }
    
    enum Action: Equatable {
        case onAppear
        case alertDismissed
        case favorite
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .alertDismissed:
                state.showRecipeFavoriteAlert = false
                return .none
                
            case .favorite:
                return .none
                
            }
        }
    }
}

extension Home.State {
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
