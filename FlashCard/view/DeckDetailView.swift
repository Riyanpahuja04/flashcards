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
                ForEach(deck.flashcardsArray, id: \.id) { flashcard in
                    HStack {
                        Text(flashcard.frontText ?? "No Text")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            selectedFlashcard = flashcard
                            showEditFlashcardView = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())

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
                // Navigation logic to study view will go here
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
    }

    // Function to delete a flashcard
    private func deleteFlashcard(at offsets: IndexSet) {
        withAnimation {
            let context = CoreDataStack.shared.context
            offsets.map { deck.flashcardsArray[$0] }.forEach(context.delete)
            saveContext()
        }
    }

    // Function to delete a specific flashcard
    private func deleteFlashcard(flashcard: FlashCard) {
        let context = CoreDataStack.shared.context
        context.delete(flashcard)
        saveContext()
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
}
