//
//  DeckDetailView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 12/10/2024.
//

import SwiftUI
import CoreData
struct DeckDetailView: View {
    @ObservedObject var deck: Deck   // The deck object passed from the previous view
    
    @State private var showAddFlashcardView = false
    @State private var showEditFlashcardView = false
    @State private var selectedFlashcard: FlashCard? = nil
    @State private var navigateToStudy: Bool = false
    
    // Fetch the flashcards associated with the current deck
    @FetchRequest private var flashcards: FetchedResults<FlashCard>
    
    init(deck: Deck) {
        self.deck = deck
        
        // Initialize FetchRequest to fetch flashcards for the current deck
        _flashcards = FetchRequest<FlashCard>(
            entity: FlashCard.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \FlashCard.createdDate, ascending: true)],
            predicate: NSPredicate(format: "deck == %@", deck)
        )
    }
    
    var body: some View {
        VStack {
            // Deck details section
            VStack(alignment: .leading, spacing: 10) {
                Text(deck.name ?? "Unnamed Deck")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(deck.descriptionText ?? "No description provided.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            // List of flashcards in the deck
            List {
                ForEach(flashcards, id: \.id) { flashcard in
                    HStack {
                        Text(flashcard.frontText ?? "No Text")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Edit button
                        Button(action: {
                            selectedFlashcard = flashcard
                            showEditFlashcardView = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        // Delete button
                        Button(action: {
                            deleteFlashcard(flashcard: flashcard)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete(perform: deleteFlashcard)
            }
            .listStyle(InsetGroupedListStyle())
            
            // Button to add a new flashcard
            Button(action: {
                showAddFlashcardView = true
            }) {
                Text("Add New Flashcard")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showAddFlashcardView) {
                AddFlashcardView(deck: deck)
            }
            
            // Button to start studying the deck
            Button(action: {
                print("Printing flash cards: \(flashcards.isEmpty)")
                for flashcard in flashcards {
                    print("Flashcard: \(flashcard.frontText ?? "No Front Text") - \(flashcard.backText ?? "No Back Text")")
                }
                
                navigateToStudy = true
            }) {
                Text("Start Studying")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationTitle(deck.name ?? "Deck Details")
        .sheet(item: $selectedFlashcard) { flashcard in
            EditFlashcardView(flashcard: flashcard)
        }
        .background(
            NavigationLink(destination: FlashcardStudyView(flashcards: flashcards.map { convertToFlashcardDataModel(flashcard: $0) }), isActive: $navigateToStudy) {
                EmptyView()
            }
        )
    }
    
    // Function to delete a specific flashcard
    private func deleteFlashcard(flashcard: FlashCard) {
        let context = CoreDataStack.shared.context
        context.delete(flashcard)
        saveContext()
    }
    
    // Function to delete selected flashcard
    private func deleteFlashcard(at offsets: IndexSet) {
        withAnimation {
            offsets.map { flashcards[$0] }.forEach { flashcard in
                deleteFlashcard(flashcard: flashcard)
            }
        }
    }
    
    // Save context function for Core Data
    private func saveContext() {
        let context = CoreDataStack.shared.context
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    // Function to convert Core Data flashcard to FlashcardDataModel (Firestore model)
    private func convertToFlashcardDataModel(flashcard: FlashCard) -> FlashcardDataModel {
        return FlashcardDataModel(
            id: flashcard.id?.uuidString ?? UUID().uuidString,
            frontText: flashcard.frontText ?? "No Front Text",
            backText: flashcard.backText ?? "No Back Text"
        )
    }
}
