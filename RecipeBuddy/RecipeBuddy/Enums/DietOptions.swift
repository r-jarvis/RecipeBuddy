//
//  DietOptions.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/23/23.
//

import Foundation

enum DietOptions: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case all
    case glutenFree
    case ketogenic
    case vegetarian
    case lactovegi
    case ovovegi
    case vegan
    case pecetarian
    case paleo
    case primal
    case lowfodmap
    case whole
    
    var description : String {
        switch self {
        case .all: return "All Recipes"
        case .glutenFree: return "Gluten Free"
        case .ketogenic: return "Ketogenic"
        case .vegetarian: return "Vegetarian"
        case .lactovegi: return "Lacto-Vegetarian"
        case .ovovegi: return "Ovo-Vegetarian"
        case .vegan: return "Vegan"
        case .pecetarian: return "Pescetarian"
        case .paleo: return "Paleo"
        case .primal: return "Primal"
        case .lowfodmap: return "Low FODMAP"
        case .whole: return "Whole30"
        }
    }
}
