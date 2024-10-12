//
//  AddFlashCardView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 12/10/2024.
//

import SwiftUI
import Foundation

struct AddFlashcardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var deck: Deck

    @State private var frontText: String = ""
    @State private var backText: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Front")) {
                    TextField("Enter front text", text: $frontText)
                }
                
                Section(header: Text("Back")) {
                    TextField("Enter back text", text: $backText)
                }
            }
            .navigationTitle("Add Flashcard")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    addFlashcard()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(frontText.isEmpty || backText.isEmpty)
            )
        }
    }

    // Function to add a new flashcard to the deck
    private func addFlashcard() {
        let context = CoreDataStack.shared.context
        let newFlashcard = FlashCard(context: context)
        newFlashcard.id = UUID()
        newFlashcard.frontText = frontText
        newFlashcard.backText = backText
        newFlashcard.createdDate = DateFormatter().string(from: Date())
        newFlashcard.deck = deck
        
        saveContext()
    }

    // Save context function for Core Data
    private func saveContext() {
        let context = CoreDataStack.shared.context
        do {
            try context.save()
        } catch {
            print("Failed to save flashcard: \(error)")
        }
    }
}

struct EditFlashcardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var flashcard: FlashCard

    var body: some View {
        Form {
            Section(header: Text("Front")) {
                TextField("Front Text", text: $flashcard.frontText.bound)
            }
            
            Section(header: Text("Back")) {
                TextField("Back Text", text: $flashcard.backText.bound)
            }
        }
        .navigationTitle("Edit Flashcard")
        .navigationBarItems(
            leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
            trailing: Button("Save") {
                saveContext()
                presentationMode.wrappedValue.dismiss()
            }
        )
    }

    // Save context function for Core Data
    private func saveContext() {
        let context = CoreDataStack.shared.context
        do {
            try context.save()
        } catch {
            print("Failed to save flashcard: \(error)")
        }
    }
}

extension Binding where Value == String? {
    var bound: Binding<String> {
        return Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0 }
        )
    }
}
