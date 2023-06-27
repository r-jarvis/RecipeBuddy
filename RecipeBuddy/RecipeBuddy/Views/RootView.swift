//
//  RootView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var store: Store<RecipeBuddy.State, RecipeBuddy.Action>
    
    struct ViewState: Equatable, Sendable {
        var selectedTab: Int
        
        init(state: RecipeBuddy.State) {
            self.selectedTab = state.selectedTab
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            TabView(selection: viewStore.binding(get: { $0.selectedTab }, send: RecipeBuddy.Action.changeTab)) {
                HomeView(store: self.store.scope(state: \.home!, action: RecipeBuddy.Action.home))
                    .accentColor(.white)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                
                FavoritesView(store: self.store.scope(state: \.favorites!, action: RecipeBuddy.Action.favorites))
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favorites")
                    }.tag(1)
                
                SettingsView(store: self.store.scope(state: \.settings!, action: RecipeBuddy.Action.settings))
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(2)
            }.accentColor(Color("NavColor"))
        }
    }
}
