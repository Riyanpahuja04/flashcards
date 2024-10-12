//
//  HomePageView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import SwiftUI
import CoreData
// Main view for the homepage
struct HomePageView: View {
    // Enum for tab selection
    enum TabSelection {
        case yourDecks
        case marketPlace
    }
    
    // State property to track selected tab
    @State private var selectedTab: TabSelection = .yourDecks
    
    var body: some View {
        NavigationView {
            VStack {
                // Segmented control for tab selection
                Picker("Select a tab", selection: $selectedTab) {
                    Text("Your Decks").tag(TabSelection.yourDecks)
                    Text("Market Place").tag(TabSelection.marketPlace)
                }
                .pickerStyle(SegmentedPickerStyle()) // Apply segmented picker style
                .padding()
                
                // Content based on the selected tab
                if selectedTab == .yourDecks {
                    YourDecksView()
                } else {
                    MarketPlaceView()
                }
            }
            .navigationBarTitle("Flashcards", displayMode: .inline)
        }
    }
}

// Placeholder view for "Your Decks" tab
struct YourDecksView: View {
    // Fetch Request to get decks stored in Core Data
    @FetchRequest(
        entity: Deck.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Deck.name, ascending: true)],
        predicate: NSPredicate(format: "isUserCreated == true OR isUserSaved == true") // Fetch user-created or saved decks
    ) var decks: FetchedResults<Deck>
    
    var body: some View {
        List(decks, id: \.id) { deck in
            NavigationLink(destination: DeckDetailView(deck: deck)) {
                Text(deck.name ?? "Unnamed Deck")
            }
        }
        .navigationTitle("Your Decks")
    }
}
// Placeholder view for "Market Place" tab
import SwiftUI

struct MarketPlaceView: View {
    // Firestore manager to handle fetching decks
    @ObservedObject private var firestoreManager = FirestoreManager()
    
    var body: some View {
        List(firestoreManager.marketPlaceDecks) { deck in
            HStack {
                VStack(alignment: .leading) {
                    Text(deck.name)
                        .font(.headline)
                    Text(deck.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    saveDeckToLocal(deck: deck)
                }) {
                    Image(systemName: "bookmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            firestoreManager.fetchMarketPlaceDecks()
        }
        .navigationTitle("Market Place")
    }
    
    // Function to save market place deck to local Core Data
    private func saveDeckToLocal(deck: DeckDataModel) {
        let context = CoreDataStack.shared.context
        let newDeck = Deck(context: context)
        newDeck.id = UUID(uuidString: deck.id) ?? UUID()
        newDeck.name = deck.name
        newDeck.descriptionText = deck.description
        newDeck.isUserCreated = false
        newDeck.isUserSaved = true
        
        do {
            try context.save()
        } catch {
            print("Failed to save deck: \(error)")
        }
    }
}

// Preview for HomePageView
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
