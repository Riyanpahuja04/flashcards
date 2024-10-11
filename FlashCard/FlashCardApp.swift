//
//  FlashCardApp.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import SwiftUI

@main
struct FlashCardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
