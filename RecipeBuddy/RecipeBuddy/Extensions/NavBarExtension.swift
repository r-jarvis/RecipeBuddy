//
//  NavBarExtension.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/27/23.
//

import Foundation
import SwiftUI

/// Extend View to be able to apply background color for navigation bar
extension View {
  func navigationBarBackground(_ background: Color = Color("NavColor")) -> some View {
    return self
      .modifier(ColoredNavigationBar(background: background))
  }
}

/// Modifier for background color on navigation bar
struct ColoredNavigationBar: ViewModifier {
  var background: Color
  
  func body(content: Content) -> some View {
    content
      .toolbarBackground(
        background,
        for: .navigationBar
      )
      .toolbarBackground(.visible, for: .navigationBar)
  }
}

/// Extend View with custom format of back button for navbar
extension View {
    func navigationBackButton(color: UIColor, text: String? = nil) -> some View {
        modifier(NavigationBackButton(color: color, text: text))
    }
}

/// Define format and style for custom back bar in navbar
struct NavigationBackButton: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    var color: UIColor
    var text: String?

    func body(content: Content) -> some View {
        return content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {  presentationMode.wrappedValue.dismiss() }, label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color(color))

                        if let text = text {
                            Text(text)
                                .foregroundColor(Color(color))
                        }
                    }
                })
            )
    }
}
