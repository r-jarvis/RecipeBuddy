//
//  InstructionStepModel.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/29/23.
//

import Foundation

struct InstructionStep: Decodable, Equatable, Sendable {
    var number: Int
    var step: String? = nil
}
