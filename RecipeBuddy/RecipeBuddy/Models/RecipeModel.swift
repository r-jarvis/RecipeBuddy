//
//  RecipeModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/14/23.
//

import Foundation

struct Recipe: Decodable, Equatable, Sendable, Identifiable {
    var id: Int
    var title: String? = nil
    var image: String? = nil
}

struct RecipeSearchResults: Decodable, Equatable, Sendable {
    var results: [Recipe] = []
}

struct RecipeDetails: Decodable, Equatable, Sendable {
    var id: Int
    var summary: String
    var title: String? = nil
    var image: String? = nil
    var analyzedInstructions: [Instructions] = []
    var extendedIngredients: [Ingredient] = []
}

struct Instructions: Decodable, Equatable, Sendable {
    var steps: [InstructionStep] = []
}

struct InstructionStep: Decodable, Equatable, Sendable {
    var number: Int
    var step: String? = nil
}

struct Ingredient: Decodable, Equatable, Sendable, Identifiable {
    var id: Int
    var nameClean: String? = nil
}
