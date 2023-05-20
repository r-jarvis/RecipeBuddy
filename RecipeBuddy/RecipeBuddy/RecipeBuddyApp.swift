//
//  RecipeBuddyApp.swift
//  RecipeBuddy
//
//  Created by Ryan Jarvis on 5/20/23.
//

import SwiftUI

@main
struct RecipeBuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
