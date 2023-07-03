//
//  IngredientModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation


/// Ingredient that can be associated with a recipe
struct Ingredient: Decodable, Equatable, Sendable, Identifiable {
    var id: Int
    var nameClean: String? = nil
}
