//
//  Deck+CoreDataProperties.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var isUserCreated: Bool
    @NSManaged public var descriptionText: String?
    @NSManaged public var firestoreID: String?
    @NSManaged public var topicID: UUID?
    @NSManaged public var topic: Topic?
    @NSManaged public var flashcards: NSSet?
    @NSManaged public var isUserSaved: Bool

}

// MARK: Generated accessors for flashcards
extension Deck {

    @objc(addFlashcardsObject:)
    @NSManaged public func addToFlashcards(_ value: FlashCard)

    @objc(removeFlashcardsObject:)
    @NSManaged public func removeFromFlashcards(_ value: FlashCard)

    @objc(addFlashcards:)
    @NSManaged public func addToFlashcards(_ values: NSSet)

    @objc(removeFlashcards:)
    @NSManaged public func removeFromFlashcards(_ values: NSSet)

}

extension Deck : Identifiable {

}
