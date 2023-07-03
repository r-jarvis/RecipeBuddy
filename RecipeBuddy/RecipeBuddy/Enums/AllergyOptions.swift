//
//  AllergyOptions.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/23/23.
//

import Foundation

// TODO: Allow for multiple allergies to be selected at once
/// Selected allergy will ensure no recipes have anything in that grouping as an ingredient 
enum AllergyOptions: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case none
    case dairy
    case egg
    case gluten
    case grain
    case peanut
    case seafood
    case sesame
    case shellfish
    case soy
    case sulfite
    case treeNut
    case wheat
    
    var description : String {
        switch self {
        case .none: return "None"
        case .dairy: return "Dairy"
        case .egg: return "Egg"
        case .gluten: return "Gluten"
        case .grain: return "Grain"
        case .peanut: return "Peanut"
        case .seafood: return "Seafood"
        case .sesame: return "Sesame"
        case .shellfish: return "Shellfish"
        case .soy: return "Soy"
        case .sulfite: return "Sulfite"
        case .treeNut: return "Tree Nut"
        case .wheat: return "Wheat"
        }
    }
}
