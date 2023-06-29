//
//  RecipeListView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/15/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct RecipeListView: View {
    var store: Store<Home.State, Home.Action>
    
    struct ViewState: Equatable, Sendable {
        var searchValue: String
        var recipes: [Recipe]
        var path: [Home.State.Route]
        
        init(state: Home.State) {
            self.searchValue = state.searchValue
            self.recipes = state.recipes
            self.path = state.path
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            ZStack {
                Color("MainColor")
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        if viewStore.recipes.count > 0 {
                            ForEach(viewStore.recipes) { recipe in
                                HomeRecipeListItemView(store: self.store, recipe: recipe)
                            }
                        } else {
                            Text("No Recipes Found")
                        }
                    }
                }.padding(.horizontal, 24)
                .accentColor(Color("NavColor"))
            }.navigationBarBackground()
        }
    }
}

struct HomeRecipeListItemView: View {
    var store: Store<Home.State, Home.Action>
    var recipe: Recipe
    
    var body: some View {
        WithViewStore(self.store, observe: RecipeListView.ViewState.init) { viewStore in
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

struct ContentView_RecipeListViewPreview: PreviewProvider {
    static var previews: some View {
        let recipes = [
            Recipe(id: 1, title: "Cannellini Bean and Asparagus Salad with Mushrooms", image: "https://spoonacular.com/recipeImages/782585-312x231.jpg"),
            Recipe(id: 2, title: "Cauliflower, Brown Rice, and Vegetable Fried Rice", image: "https://spoonacular.com/recipeImages/716426-312x231.jpg"),
            Recipe(id: 3, title: "Berry Banana Breakfast Smoothie", image: "https://spoonacular.com/recipeImages/715497-312x231.jpg"),
            Recipe(id: 4, title: "Red Lentil Soup with Chicken and Turnips", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg"),
            Recipe(id: 5, title: "Asparagus and Pea Soup: Real Convenience Food", image: "https://spoonacular.com/recipeImages/716406-312x231.jpg"),
            Recipe(id: 6, title: "Garlicky Kale", image: "https://spoonacular.com/recipeImages/644387-312x231.jpg"),
            Recipe(id: 7, title: "Slow Cooker Beef Stew", image: "https://spoonacular.com/recipeImages/715446-312x231.jpg"),
            Recipe(id: 8, title: "Red Kidney Bean Jambalaya", image: "https://spoonacular.com/recipeImages/782601-312x231.jpg")
        ]
        
        let homeState = Home.State(recipes: recipes)
        let store = Store(initialState: RecipeBuddy.State(home: homeState), reducer: RecipeBuddy()).scope(state: \.home!, action: RecipeBuddy.Action.home)
        RecipeListView(store: store)
    }
}
