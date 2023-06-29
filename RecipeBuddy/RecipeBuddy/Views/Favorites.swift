//
//  Favorites.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/20/23.
//


import Foundation
import ComposableArchitecture
import SwiftUI

struct FavoritesView: View {
    var store: Store<Favorites.State, Favorites.Action>
    
    struct ViewState: Equatable, Sendable {
        var path: [Favorites.State.Route]
        var recipes: [Recipe]
        var selectedRecipe: RecipeDetails?
        
        init(state: Favorites.State) {
            self.path = state.path
            self.recipes = state.recipes
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
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            if viewStore.recipes.count > 0 {
                                ForEach(viewStore.recipes) { recipe in
                                    FavoritesRecipeListItemView(store: self.store, recipe: recipe)
                                }
                            } else {
                                Text("No Recipes Found")
                            }
                        }.accentColor(Color("NavColor"))
                    }.padding(24)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Favorites")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                    .navigationDestination(for: Favorites.State.Route.self) { route in
                        switch route {
                        case .recipe:
                            RecipeView(store: self.store.scope(state: \.recipe!, action: Favorites.Action.recipe), showFavoriteButton: false)
                                .accentColor(.white)
                        }
                    }
                }
                .navigationBarBackground()
                .onAppear{
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}
struct FavoritesRecipeListItemView: View {
    var store: Store<Favorites.State, Favorites.Action>
    var recipe: Recipe
    
    var body: some View {
        WithViewStore(self.store, observe: FavoritesView.ViewState.init) { viewStore in
            Button(action: {
                viewStore.send(.selectRecipe(recipe))
            }) {
                HStack {
                    AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 120, height: 120)
                    
                    Spacer()
                    
                    Text("\(recipe.title ?? "Recipe")")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
    }
}

struct ContentView_FavoritesPreview: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: RecipeBuddy.State(home: Home.State()), reducer: RecipeBuddy()).scope(state: \.favorites!, action: RecipeBuddy.Action.favorites)
        FavoritesView(store: store)
    }
}
