//
//  CoreDataStack.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 12/10/2024.
//

import Foundation
import CoreData

// Singleton class to manage Core Data operations
class CoreDataStack {
    
    // Shared instance to access the CoreDataStack from anywhere in the app
    static let shared = CoreDataStack()
    
    // Name of the Core Data model (replace with your actual model name if it's different)
    private let modelName: String = "FlashCard"
    
    // The persistent container for the application. This implementation creates and returns a container,
    // having loaded the store for the application to it.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // The main context to interact with Core Data
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save the context if there are any changes
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
