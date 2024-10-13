//
//  HomePageView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 11/10/2024.
//

import SwiftUI
import CoreData
import FirebaseFirestore
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
import SwiftUI
import CoreData

struct YourDecksView: View {
    @State var showCreateDeckView: Bool = false  // Binding to manage the create deck view

    // Fetch user-generated or saved decks from Core Data
    @FetchRequest(
        entity: Deck.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Deck.name, ascending: true)],
        predicate: NSPredicate(format: "isUserCreated == true OR isUserSaved == true")
    ) var decks: FetchedResults<Deck>
    
    var body: some View {
        VStack {
            if decks.isEmpty {
                Text("Create or save a deck from market place to view it here!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            List(decks, id: \.id) { deck in
                NavigationLink(destination: DeckDetailView(deck: deck)) {
                    VStack(alignment: .leading) {
                        Text(deck.name ?? "Unnamed Deck")
                            .font(.headline)
                        Text(deck.descriptionText ?? "No description provided.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Your Decks")
            
            // "Create New Deck" button
            Button(action: {
                showCreateDeckView = true  // Show the create deck modal when tapped
            }) {
                Text("Create New Deck")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
                .sheet(isPresented: $showCreateDeckView) {
                        CreateDeckView()  // Present the create deck view as a sheet
                    }
        }
    }
}

struct MarketPlaceView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var savedDecks = Set<String>()  // Keep track of saved deck IDs
    
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
                
                // Bookmark button, changing color based on saved state
                Button(action: {
                    toggleSaveDeck(deck: deck)
                }) {
                    Image(systemName: savedDecks.contains(deck.id) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(savedDecks.contains(deck.id) ? .blue : .gray)
                }
            }
        }
        .onAppear {
            firestoreManager.fetchMarketPlaceDecks()
        }
        .navigationTitle("Market Place")
    }
    
    // Toggle the saved state of the deck
    private func toggleSaveDeck(deck: DeckDataModel) {
        if savedDecks.contains(deck.id) {
            // If already saved, remove it from saved decks
            savedDecks.remove(deck.id)
            removeDeckFromLocal(deck: deck)
        } else {
            // If not saved, add it to saved decks
            savedDecks.insert(deck.id)
            saveDeckToLocal(deck: deck)
        }
    }
    
    // Save the deck to local storage (Core Data, Firebase, etc.)
    private func saveDeckToLocal(deck: DeckDataModel) {
        let context = CoreDataStack.shared.context
        let newDeck = Deck(context: context)
        
        // Save the deck data
        newDeck.id = UUID(uuidString: deck.id) ?? UUID()
        newDeck.name = deck.name
        newDeck.descriptionText = deck.description
        newDeck.isUserCreated = false
        newDeck.isUserSaved = true
        print(deck.flashcards.isEmpty)
        // Iterate over the flashcards and save them in Core Data
        for flashcardData in deck.flashcards {
            let newFlashcard = FlashCard(context: context)
            newFlashcard.id = UUID(uuidString: flashcardData.id) ?? UUID()
            newFlashcard.frontText = flashcardData.frontText
            newFlashcard.backText = flashcardData.backText
            newFlashcard.createdDate = DateFormatter().string(from: Date())
            
            // Link the flashcard to the deck
            newFlashcard.deck = newDeck
        }
        
        // Save the context
        do {
            try context.save()
            print("Deck and flashcards saved successfully")
        } catch {
            print("Failed to save deck and flashcards: \(error)")
        }
    }
    // Remove the deck from saved decks (if unsaved)
    private func removeDeckFromLocal(deck: DeckDataModel) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", deck.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let deckToDelete = results.first {
                context.delete(deckToDelete)
                try context.save()
                print("Deck removed from saved decks")
            }
        } catch {
            print("Failed to remove deck: \(error)")
        }
    }
}

// Preview for HomePageView
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
