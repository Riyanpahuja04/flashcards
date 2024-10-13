//
//  FireStoreManager.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//
import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    @Published var marketPlaceDecks = [DeckDataModel]()
    private let db = Firestore.firestore()
    
    // Fetch decks and their associated flashcards from Firestore
    func fetchMarketPlaceDecks() {
        db.collection("marketPlaceDecks").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching decks: \(error)")
                return
            }
            
            if let snapshot = snapshot {
                var decks = [DeckDataModel]()
                let dispatchGroup = DispatchGroup() // To manage asynchronous fetches
                
                for document in snapshot.documents {
                    let deckData = document.data()
                    let deckID = document.documentID
                    let name = deckData["name"] as? String ?? ""
                    let description = deckData["description"] as? String ?? ""
                    
                    // Create a temporary deck object (empty flashcards for now)
                    var deck = DeckDataModel(id: deckID, name: name, description: description, flashcards: [])
                    
                    // Enter the dispatch group
                    dispatchGroup.enter()
                    
                    // Fetch flashcards for this deck
                    self.fetchFlashcards(forDeck: deckID) { flashcards in
                        deck.flashcards = flashcards
                        decks.append(deck)
                        dispatchGroup.leave()  // Leave once flashcards are fetched
                    }
                }
                
                // Wait for all flashcards to be fetched before updating the UI
                dispatchGroup.notify(queue: .main) {
                    self.marketPlaceDecks = decks
                }
            }
        }
    }
    
    // Fetch flashcards for a specific deck
    private func fetchFlashcards(forDeck deckID: String, completion: @escaping ([FlashcardDataModel]) -> Void) {
        let flashcardsRef = db.collection("marketPlaceDecks").document(deckID).collection("flashcards")
        
        flashcardsRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching flashcards: \(error)")
                completion([])
                return
            }
            
            var flashcards = [FlashcardDataModel]()
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let flashcardData = document.data()
                    let flashcardID = document.documentID
                    let frontText = flashcardData["frontText"] as? String ?? ""
                    let backText = flashcardData["backText"] as? String ?? ""
                    
                    let flashcard = FlashcardDataModel(id: flashcardID, frontText: frontText, backText: backText)
                    flashcards.append(flashcard)
                }
            }
            print("below are the flashcards: \(flashcards.isEmpty)")
            
            
            completion(flashcards)
        }
    }
}

// Simple data model for decks fetched from Firestore
struct DeckDataModel: Identifiable, Codable {
    var id: String
    var name: String
    var description: String?
    var flashcards: [FlashcardDataModel]  // Array to hold the flashcards
}

struct FlashcardDataModel: Identifiable, Codable {
    var id: String
    var frontText: String
    var backText: String
}
