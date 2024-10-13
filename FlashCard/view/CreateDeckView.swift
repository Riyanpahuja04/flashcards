//
//  CreateDeckView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 13/10/2024.
//

import SwiftUI
import CoreData

struct CreateDeckView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var deckName: String = ""
    @State private var deckDescription: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Information")) {
                    TextField("Deck Name", text: $deckName)
                    TextField("Description", text: $deckDescription)
                }
                
                Button(action: {
                    saveDeck()
                }) {
                    Text("Save Deck")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(deckName.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(deckName.isEmpty)  // Disable button if deck name is empty
            }
            .navigationTitle("Create New Deck")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    // Save the new deck to Core Data
    private func saveDeck() {
        let context = CoreDataStack.shared.context
        let newDeck = Deck(context: context)
        newDeck.id = UUID()
        newDeck.name = deckName
        newDeck.descriptionText = deckDescription
        newDeck.isUserCreated = true
        newDeck.isUserSaved = false
        
        do {
            try context.save()
            print("Deck saved successfully")
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save deck: \(error)")
        }
    }
}
