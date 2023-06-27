//
//  RecipePDFView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/19/23.
//


import Foundation
import ComposableArchitecture
import SwiftUI

struct RecipePDFView: View {
    var recipe: RecipeDetails?
    
    var body: some View {
        if let recipe = self.recipe {
            VStack(alignment: .leading) {
                Text("\(recipe.title ?? "Recipe")")
                    .font(.system(size: 24, weight: .semibold))
                    .padding(.bottom, 18)
                
                Text("Ingredients")
                    .font(.system(size: 18, weight: .semibold))
                
                VStack(alignment: .leading) {
                    ForEach(recipe.extendedIngredients) { ingredient in
                        Text("\(ingredient.nameClean ?? "INGRED MISSING")")
                    }
                }.padding(.bottom, 28)
                
                Text("Instructions")
                    .font(.system(size: 18, weight: .semibold))
                
                VStack(alignment: .leading) {
                    ForEach(recipe.analyzedInstructions[0].steps, id: \.self.number) { instruction in
                        Text("\(instruction.number): \(instruction.step ?? "INSTRUCT MISSING")")
                            .padding(.bottom, 6)
                    }
                }
            }.frame(width: 400)
                .padding(24)
        } else {
            Text("Loading Recipe...")
        }
    }
}
