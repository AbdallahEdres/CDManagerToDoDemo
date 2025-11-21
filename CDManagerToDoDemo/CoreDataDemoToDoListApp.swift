//
//  CDManagerToDoDemoApp.swift
//  CDManagerToDoDemo
//
//  Created by Abdallah Edres on 21/11/2025.
//

import SwiftUI
import CoreData

@main
struct CDManagerToDoDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

