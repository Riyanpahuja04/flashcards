//
//  FlashCardApp.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct FlashCardApp: App {
    let persistenceController = CoreDataStack.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomePageView()
            }
            .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
