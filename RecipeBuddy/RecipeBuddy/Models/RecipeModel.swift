//
//  RecipeModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/14/23.
//

import Foundation

/// High level recipe details used on recipe-list screens
struct Recipe: Decodable, Equatable, Sendable, Identifiable {
    var id: Int
    var title: String? = nil
    var image: String? = nil
}
