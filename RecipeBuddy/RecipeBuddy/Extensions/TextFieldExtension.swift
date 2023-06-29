//
//  TextFieldExtension.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/28/23.
//

import Foundation
import SwiftUI

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

extension View {
    func focusablePadding(_ edges: Edge.Set = .all, _ size: CGFloat? = nil) -> some View {
        modifier(FocusablePadding(edges, size))
    }
}

private struct FocusablePadding : ViewModifier {
    
    private let edges: Edge.Set
    private let size: CGFloat?
    @FocusState private var focused: Bool
    
    init(_ edges: Edge.Set, _ size: CGFloat?) {
        self.edges = edges
        self.size = size
        self.focused = false
    }
    
    func body(content: Content) -> some View {
        content
            .focused($focused)
            .padding(edges, size)
            .contentShape(Rectangle())
            .onTapGesture { focused = true }
    }
    
}
