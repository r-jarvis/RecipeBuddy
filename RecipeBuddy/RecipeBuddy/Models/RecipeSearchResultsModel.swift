//
//  RecipeSearchResultsModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation

struct RecipeSearchResults: Decodable, Equatable, Sendable {
    var results: [Recipe] = []
}
