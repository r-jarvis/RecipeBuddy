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
    let store = Store(initialState: RecipeBuddy.AppState(), reducer: RecipeBuddy())
    
    var body: some Scene {
        WindowGroup {
            RootView(store: self.store)
        }
    }
}

struct AppEnvironment {
    // Define the dependencies your app needs here
}

public struct RecipeBuddy: ReducerProtocol {
    public struct AppState {
        var selectedTab: Int = 0
    }
    
    public enum AppAction {
        case onAppear
        case changeTab(Int)
    }
    
    public init() {}

    public var body: some ReducerProtocol<AppState, AppAction> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .changeTab(tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}
