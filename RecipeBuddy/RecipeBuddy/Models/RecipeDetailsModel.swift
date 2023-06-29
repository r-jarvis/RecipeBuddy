//
//  RecipeDetailsModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation

struct RecipeDetails: Decodable, Equatable, Sendable {
    var id: Int
    var summary: String
    var title: String? = nil
    var image: String? = nil
    var analyzedInstructions: [Instructions] = []
    var extendedIngredients: [Ingredient] = []
}
