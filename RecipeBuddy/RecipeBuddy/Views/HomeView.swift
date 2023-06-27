//
//  HomeView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    init(store: Store<Home.State, Home.Action>) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color("NavColor"))
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        self.store = store
    }
    
    var store: Store<Home.State, Home.Action>
    
    struct ViewState: Equatable, Sendable {
        var searchValue: String
        var recipes: [Recipe]
        var path: [Home.State.Route]
        var selectedRecipe: RecipeDetails?
        
        init(state: Home.State) {
            self.searchValue = state.searchValue
            self.recipes = state.recipes
            self.path = state.path
            self.selectedRecipe = state.selectedRecipe
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: { .pathChanged($0) }
                )
            ) {
                ZStack {
                    Color("MainColor")
                    VStack {
                        Image("SplashImage")
                            .resizable()
                            .frame(width: 350, height: 350)
                        
                        TextField("Leave Blank for Random Recipes!", text: viewStore.binding(get: { $0.searchValue }, send: Home.Action.searchFieldChanged))
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 4)
                            .background(.white)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("ButtonColor")))
                            .padding([.horizontal], 24)
                            
                        
                        Button(action: {
                            viewStore.send(.search)
                        }) {
                            Text("Search")
                        }
                        .padding(.horizontal, 84)
                        .padding(.vertical, 18)
                        .background(Color("ButtonColor"))
                        .foregroundColor(Color.white)
                        .cornerRadius(24)
                        
                        Spacer()
                    }
                    .navigationBarTitle("Home", displayMode: .inline)
                    .navigationDestination(for: Home.State.Route.self) { route in
                        switch route {
                        case .recipeList:
                            RecipeListView(store: self.store)
                                .accentColor(.white)
                        case .recipe:
                            RecipeView(store: self.store.scope(state: \.recipe!, action: Home.Action.recipe))
                                .accentColor(.white)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_HomePreview: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: RecipeBuddy.State(home: Home.State()), reducer: RecipeBuddy()).scope(state: \.home!, action: RecipeBuddy.Action.home)
        HomeView(store: store)
    }
}
