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
                        
                        VStack {
                            TextField("Leave Blank for Random Recipes!", text: viewStore.binding(get: { $0.searchValue }, send: Home.Action.searchFieldChanged))
                                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                .accentColor(Color.black)
                                .background(Color.white)
                                .cornerRadius(26)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 26)
                                        .stroke(lineWidth: 2.0)
                                        .foregroundColor(Color("NavColor"))
                                )
                        }.padding(.horizontal, 24)
                            
                        
                        Button(action: {
                            viewStore.send(.search)
                        }) {
                            Text("Search")
                                .contentShape(Rectangle())
                                .frame(width: 210, height: 50)
                        }
                        
                        .background(Color("ButtonColor"))
                        .foregroundColor(Color.white)
                        .cornerRadius(24)
                        
                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Home")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                    .navigationDestination(for: Home.State.Route.self) { route in
                        switch route {
                        case .recipeList:
                            RecipeListView(store: self.store)
                                .accentColor(.white)
                        case .recipe:
                            RecipeView(store: self.store.scope(state: \.recipe!, action: Home.Action.recipe), showFavoriteButton: true)
                                .accentColor(.white)
                        }
                    }
                }.navigationBarBackground()
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
