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
        
        /// Local state
        var showRecipeFavoriteAlert: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case alertDismissed
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
                
            }
        }
    }
}

extension Home.State {
    var recipe: RecipeReducer.State? {
        get {
            RecipeReducer.State(
                selectedRecipe: self.selectedRecipe
            )
        }
        set {
            self.selectedRecipe = newValue?.selectedRecipe
        }
    }
}
