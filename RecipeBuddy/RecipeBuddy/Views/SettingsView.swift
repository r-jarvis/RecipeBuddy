//
//  SettingsView.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 6/22/23.
//



import Foundation
import ComposableArchitecture
import SwiftUI
import Combine

struct SettingsView: View {
    var store: Store<Settings.State, Settings.Action>
    
    @AppStorage("diet") private var diet: DietOptions = .all
    @AppStorage("allergies") private var allergies: AllergyOptions = .none
    @AppStorage("recipeType") private var recipeType: RecipeTypeOptions = .all
    @AppStorage("cuisine") private var cuisine: CuisineOptions = .all
    
    struct ViewState: Equatable, Sendable {
        
        init(state: Settings.State) { }
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker("Diet", selection: $diet) {
                        ForEach(DietOptions.allCases) { option in
                            Text(option.description)
                        }
                    }
                    Picker("Allergies", selection: $allergies) {
                        ForEach(AllergyOptions.allCases) { option in
                            Text(option.description)
                        }
                    }
                    Picker("Recipe Type", selection: $recipeType) {
                        ForEach(RecipeTypeOptions.allCases) { option in
                            Text(option.description)
                        }
                    }
                    Picker("Cuisine", selection: $cuisine) {
                        ForEach(CuisineOptions.allCases) { option in
                            Text(option.description)
                        }
                    }
                } header: {
                    Text("Settings").sectionHeaderStyle()
                }
            }
        }
    }
}

public extension Text {
    func sectionHeaderStyle() -> some View {
        self
            .font(.system(.title))
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .textCase(nil)
    }
}
