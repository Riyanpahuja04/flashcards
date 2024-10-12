//
//  Topic+CoreDataProperties.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var isUserCreated: Bool
    @NSManaged public var firestoreID: String?
    @NSManaged public var decks: NSSet?

}

// MARK: Generated accessors for decks
extension Topic {

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: Deck)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: Deck)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSSet)

}

extension Topic : Identifiable {

}
