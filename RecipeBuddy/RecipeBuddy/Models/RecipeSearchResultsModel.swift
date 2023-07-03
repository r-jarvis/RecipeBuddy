//
//  RecipeSearchResultsModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation

/// Array of recipes used on recipe-lists screens
struct RecipeSearchResults: Decodable, Equatable, Sendable {
    var results: [Recipe] = []
}
