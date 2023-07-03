//
//  RecipeTypeOptions.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/23/23.
//

import Foundation

/// If a recipe type  is selected, only recipes that match that  type will be returned
enum RecipeTypeOptions: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case all
    case mainCourse
    case sideDish
    case dessert
    case appetizer
    case salad
    case bread
    case breakfast
    case soup
    case beverage
    case sauce
    case marinade
    case fingerfood
    case snack
    case drink
    
    var description : String {
        switch self {
        case .all: return "All Recipes"
        case .mainCourse: return "Main Course"
        case .sideDish: return "Side Dish"
        case .dessert: return "Dessert"
        case .appetizer: return "Appetizer"
        case .salad: return "Salad"
        case .bread: return "Bread"
        case .breakfast: return "Breakfast"
        case .soup: return "Soup"
        case .beverage: return "Beverage"
        case .sauce: return "Sauce"
        case .marinade: return "Marinade"
        case .fingerfood: return "Fingerfood"
        case .snack: return "Snack"
        case .drink: return "Drink"
            
        }
    }
}
