//
//  RootView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var store: Store<RecipeBuddy.AppState, RecipeBuddy.AppAction>
    
    struct ViewState: Equatable, Sendable {
        var selectedTab: Int
        
        init(state: RecipeBuddy.AppState) {
            self.selectedTab = state.selectedTab
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            TabView(selection: viewStore.binding(get: { $0.selectedTab }, send: RecipeBuddy.AppAction.changeTab)) {
                Text("Tab 1")
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("Tab 1")
                    }.tag(0)
                
                Text("Tab 2")
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Tab 2")
                    }.tag(1)
                
                Text("Tab 3")
                    .tabItem {
                        Image(systemName: "3.square.fill")
                        Text("Tab 3")
                    }.tag(2)
            }
        }
    }
}
