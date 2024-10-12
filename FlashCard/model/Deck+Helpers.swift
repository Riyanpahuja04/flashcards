//
//  Deck+Helpers.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 12/10/2024.
//

import Foundation
import CoreData

extension Deck {
    var flashcardsArray: [FlashCard] {
        let set = flashcards as? Set<FlashCard> ?? []
        let dateFormatter = DateFormatter()
        return set.sorted {
            $0.createdDate ?? dateFormatter.string(from: Date()) < $1.createdDate ?? dateFormatter.string(from: Date())
        }
    }
}
