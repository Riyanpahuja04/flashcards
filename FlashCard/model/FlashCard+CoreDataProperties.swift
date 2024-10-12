//
//  FlashCard+CoreDataProperties.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//
//

import Foundation
import CoreData


extension FlashCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlashCard> {
        return NSFetchRequest<FlashCard>(entityName: "FlashCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var frontText: String?
    @NSManaged public var backText: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var firestoreID: String?
    @NSManaged public var deckID: UUID?
    @NSManaged public var deck: Deck?

}

extension FlashCard : Identifiable {

}
