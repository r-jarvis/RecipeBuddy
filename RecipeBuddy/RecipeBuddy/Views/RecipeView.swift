//
//  RecipeView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/15/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct RecipeView: View {
    var store: Store<RecipeReducer.State, RecipeReducer.Action>
    var showFavoriteButton: Bool
    
    struct ViewState: Equatable, Sendable {
        var selectedRecipe: RecipeDetails? = nil
        var showRecipeFavoriteAlert: Bool = false
        var recipeSearchError: Bool = false
        
        init(state: RecipeReducer.State) {
            self.selectedRecipe = state.selectedRecipe
            self.showRecipeFavoriteAlert = state.showRecipeFavoriteAlert
            self.recipeSearchError = state.recipeSearchError
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            ZStack {
                Color("MainColor")
                ScrollView(.vertical) {
                    if let recipe = viewStore.selectedRecipe {
                        VStack(alignment: .leading) {
                            HStack {
                                AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 120, height: 120)
                                
                                Text("\(recipe.title ?? "Recipe")")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            
                            HStack {
                                ShareLink("Share", item: render(recipe))
                                    .padding(.horizontal, 28)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(24)
                                
                                Spacer()
                                
                                if showFavoriteButton {
                                    Button(action: {
                                        viewStore.send(.favorite)
                                    }) {
                                        HStack {
                                            Image(systemName: "star")
                                            Text("Favorite")
                                        }
                                    }
                                    .padding(.horizontal, 28)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(24)
                                }
                            }
                            
                            Text("Ingredients")
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                ForEach(recipe.extendedIngredients) { ingredient in
                                    Text("\(ingredient.nameClean ?? "None")")
                                }
                            }.padding(.bottom, 28)
                            
                            Text("Instructions")
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                ForEach(recipe.analyzedInstructions[0].steps, id: \.self.number) { instruction in
                                    Text("\(instruction.number): \(instruction.step ?? "None")")
                                        .padding(.bottom, 6)
                                }
                            }
                        }
                    } else if viewStore.recipeSearchError {
                        Text("Sorry! There was an issue loading this recipe. Please go back and try a different one!")
                            .padding(.top, 48)
                    } else {
                        Text("Loading Recipe...")
                            .padding(.top, 48)
                    }
                }
                .padding(.horizontal, 24)
                .alert("\(viewStore.selectedRecipe?.title ?? "Recipe ") had been added to your favorites!", isPresented:  viewStore.binding(get: { $0.showRecipeFavoriteAlert }, send: RecipeReducer.Action.alertDismissed)) {
                    Button("OK", role: .cancel) { }
                }
                .navigationBackButton(color: .white, text: "Back")
                .navigationBarBackground()
            }
        }
    }
    
    @MainActor func render(_ recipe: RecipeDetails) -> URL {
        let renderer = ImageRenderer(content: RecipePDFView(recipe: recipe))
        let url = URL.documentsDirectory.appending(path: "\(recipe.title ?? "Recipe").pdf")

        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            pdf.beginPDFPage(nil)
            context(pdf)

            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let instructions = Instructions(steps: [
            InstructionStep(number: 1, step: "Rinse the cannellini beans and soak for 8 hours or overnight in several inches of water."),
            InstructionStep(number: 2, step: "Drain and rinse, then transfer to a medium saucepan and cover with fresh water."),
            InstructionStep(number: 3, step: "Add the curry leaves or bay leaf and bring to a boil. Reduce heat to medium-low, cover, and simmer for 1 hour or until the beans are tender but not falling apart."),
            InstructionStep(number: 4, step: "Drain and transfer to a large salad bowl.Meanwhile, snap the woody ends off of the asparagus spears and steam the spears for 6 minutes or until just tender but still retaining their crunch.")
        ])
        
        let ingredients = [
            Ingredient(id: 1, nameClean: "dried cannellini beans"),
            Ingredient(id: 2, nameClean: "curry leaves"),
            Ingredient(id: 3, nameClean: "tarragon"),
            Ingredient(id: 4, nameClean: "garlic"),
            Ingredient(id: 5, nameClean: "lemon juice"),
            Ingredient(id: 6, nameClean: "olive oil"),
            Ingredient(id: 7, nameClean: "black pepper"),
            Ingredient(id: 8, nameClean: "coarse sea salt"),
        ]
        
        let recipeDetails = RecipeDetails(id: 1,
                                          summary: "TestSummary",
                                          title: "Cannellini Bean and Asparagus Salad with Mushrooms",
                                          image: "https://spoonacular.com/recipeImages/782585-556x370.jpg",
                                          analyzedInstructions: [instructions],
                                          extendedIngredients: ingredients
        )
        
        let homeState = Home.State(selectedRecipe: recipeDetails)
        let store = Store(initialState: RecipeBuddy.State(home: homeState), reducer: RecipeBuddy()).scope(state: \.home!, action: RecipeBuddy.Action.home).scope(state: \.recipe!, action: Home.Action.recipe)
        RecipeView(store: store, showFavoriteButton: true)
    }
}
