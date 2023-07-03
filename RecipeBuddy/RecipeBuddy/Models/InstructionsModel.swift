//
//  InstructionsModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation

/// Array of InstructionaStep associated with a Recipe
struct Instructions: Decodable, Equatable, Sendable {
    var steps: [InstructionStep] = []
}
