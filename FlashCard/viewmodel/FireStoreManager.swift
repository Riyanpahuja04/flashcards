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
    
    // Fetch decks from Firestore
    func fetchMarketPlaceDecks() {
        db.collection("marketPlaceDecks").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching decks: \(error)")
                return
            }
            
            if let snapshot = snapshot {
                self.marketPlaceDecks = snapshot.documents.compactMap { document -> DeckDataModel? in
                    try? document.data(as: DeckDataModel.self)
                }
            }
        }
    }
}

// Simple data model for decks fetched from Firestore
struct DeckDataModel: Identifiable, Codable {
    var id: String
    var name: String
    var description: String?
}
