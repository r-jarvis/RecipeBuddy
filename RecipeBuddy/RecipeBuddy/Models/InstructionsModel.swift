//
//  InstructionsModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation

struct Instructions: Decodable, Equatable, Sendable {
    var steps: [InstructionStep] = []
}
