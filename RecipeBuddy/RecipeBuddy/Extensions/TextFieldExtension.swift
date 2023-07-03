//
//  TextFieldExtension.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/28/23.
//

import Foundation
import SwiftUI

/// Custom TextFieldStyle for the button on the home screen
public struct HomeTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 55)
            .textFieldStyle(PlainTextFieldStyle())
            .background(.white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("ButtonColor")))
            .accentColor(.black)
            .padding(10)
    }
}
