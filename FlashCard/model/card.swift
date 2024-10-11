//
//  card.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import Foundation
import CoreData
import FirebaseFirestore

@objc(Topic)
public class Topic: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var descriptionText: String?
    @NSManaged public var isUserCreated: Bool
    @NSManaged public var firestoreID: String?
    @NSManaged public var decks: Set<Deck>?
}

extension Topic {
    // Convert Core Data Topic to Firestore-compatible dictionary
    func toFirestoreDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "descriptionText": descriptionText ?? "",
            "isUserCreated": isUserCreated
        ]
    }

    // Create a Topic object from Firestore document snapshot
    static func fromFirestore(document: DocumentSnapshot, context: NSManagedObjectContext) -> Topic {
        let topic = Topic(context: context)
        topic.firestoreID = document.documentID
        topic.id = UUID(uuidString: document.get("id") as? String ?? "") ?? UUID()
        topic.name = document.get("name") as? String ?? ""
        topic.descriptionText = document.get("descriptionText") as? String
        topic.isUserCreated = document.get("isUserCreated") as? Bool ?? false
        return topic
    }
}
