//
//  AppCore.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import Foundation
import ComposableArchitecture
import CoreData

struct AppEnvironment {
    // Define the dependencies your app needs here
}

struct RecipeBuddy: ReducerProtocol {
    public struct State {
        var selectedTab: Int = 0
        var home: Home.State? = Home.State()
        var favorites: Favorites.State? = Favorites.State()
        var settings: Settings.State? = Settings.State()
    }
    
    enum Action {
        case onAppear
        case changeTab(Int)
        case home(Home.Action)
        case favorites(Favorites.Action)
        case settings(Settings.Action)
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .changeTab(tab):
                state.selectedTab = tab
                return .none
            case .home, .favorites, .settings:
                return .none
            }
        }
        .ifLet(\.home, action: /Action.home) {
            Home()
        }
        .ifLet(\.favorites, action: /Action.favorites) {
            Favorites()
        }
        .ifLet(\.settings, action: /Action.settings) {
            Settings()
        }
    }
}
