//
//  CuisineOptions.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/23/23.
//

import Foundation

enum CuisineOptions: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case all
    case african
    case asian
    case american
    case british
    case cajun
    case caribbean
    case chinese
    case french
    case german
    case greek
    case indian
    case italian
    case japanese
    case korean
    case latinAmerican
    case mexican
    case nordic
    case southern
    case spanish
    case thai
    
    var description : String {
        switch self {
        case .all: return "All Cuisines"
        case .african: return "African"
        case .asian: return "Asian"
        case .american: return "American"
        case .british: return "British"
        case .cajun: return "Cajun"
        case .caribbean: return "Caribbean"
        case .chinese: return "Chinese"
        case .french: return "French"
        case .german: return "German"
        case .greek: return "Greek"
        case .indian: return "Indian"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .latinAmerican: return "Latin American"
        case .mexican: return "Mexican"
        case .nordic: return "Nordic"
        case .southern: return "Southern"
        case .spanish: return "Spanish"
        case .thai: return "Thai"
        }
    }
}
