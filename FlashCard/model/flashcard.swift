//
//  flashcard.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import Foundation
import CoreData
import FirebaseFirestore

@objc(Flashcard)
public class Flashcard: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var frontText: String
    @NSManaged public var backText: String
    @NSManaged public var createdDate: Date
    @NSManaged public var firestoreID: String?
    @NSManaged public var deckID: UUID?
    @NSManaged public var deck: Deck?
}

extension Flashcard {
    // Convert Core Data Flashcard to Firestore-compatible dictionary
    func toFirestoreDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "frontText": frontText,
            "backText": backText,
            "createdDate": Timestamp(date: createdDate),
            "deckID": deckID?.uuidString ?? ""
        ]
    }

    // Create a Flashcard object from Firestore document snapshot
    static func fromFirestore(document: DocumentSnapshot, context: NSManagedObjectContext) -> Flashcard {
        let flashcard = Flashcard(context: context)
        flashcard.firestoreID = document.documentID
        flashcard.id = UUID(uuidString: document.get("id") as? String ?? "") ?? UUID()
        flashcard.frontText = document.get("frontText") as? String ?? ""
        flashcard.backText = document.get("backText") as? String ?? ""
        flashcard.createdDate = (document.get("createdDate") as? Timestamp)?.dateValue() ?? Date()
        if let deckIDString = document.get("deckID") as? String {
            flashcard.deckID = UUID(uuidString: deckIDString)
        }
        return flashcard
    }
}
