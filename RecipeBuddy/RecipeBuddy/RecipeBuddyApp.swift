//
//  RecipeBuddyApp.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import SwiftUI
import Foundation
import ComposableArchitecture

@main
struct RecipeBuddyApp: App {
    let store = Store(initialState: RecipeBuddy.State(home: Home.State()), reducer: RecipeBuddy())
    
    var body: some Scene {
        WindowGroup {
            RootView(store: self.store)
        }
    }
}
