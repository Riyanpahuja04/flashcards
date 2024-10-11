//
//  deck.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import Foundation
import CoreData
import FirebaseFirestore

@objc(Deck)
public class Deck: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var descriptionText: String?
    @NSManaged public var isUserCreated: Bool
    @NSManaged public var firestoreID: String?
    @NSManaged public var topicID: UUID?
    @NSManaged public var flashcards: Set<Flashcard>?
    @NSManaged public var topic: Topic?
}

extension Deck {
    // Convert Core Data Deck to Firestore-compatible dictionary
    func toFirestoreDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "descriptionText": descriptionText ?? "",
            "isUserCreated": isUserCreated,
            "topicID": topicID?.uuidString ?? ""
        ]
    }

    // Create a Deck object from Firestore document snapshot
    static func fromFirestore(document: DocumentSnapshot, context: NSManagedObjectContext) -> Deck {
        let deck = Deck(context: context)
        deck.firestoreID = document.documentID
        deck.id = UUID(uuidString: document.get("id") as? String ?? "") ?? UUID()
        deck.name = document.get("name") as? String ?? ""
        deck.descriptionText = document.get("descriptionText") as? String
        deck.isUserCreated = document.get("isUserCreated") as? Bool ?? false
        if let topicIDString = document.get("topicID") as? String {
            deck.topicID = UUID(uuidString: topicIDString)
        }
        return deck
    }
}
