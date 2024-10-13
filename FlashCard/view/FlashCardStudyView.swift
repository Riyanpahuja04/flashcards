//
//  FlashCardStudyView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 13/10/2024.
//

import SwiftUI

struct FlashcardStudyView: View {
    var flashcards: [FlashCard]  // List of flashcards to study
    @State private var currentIndex = 0  // Track the current flashcard
    @State private var showBack = false  // Track if the card is flipped
    
    var body: some View {
        VStack {
            if flashcards.isEmpty {
                Text("No flashcards available")
                    .font(.headline)
            } else {
                VStack {
                    Text(showBack ? flashcards[currentIndex].backText ?? "Back" : flashcards[currentIndex].frontText ?? "Front")
                        .font(.largeTitle)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onTapGesture {
                            flipFlashcard()
                        }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            showPreviousCard()
                        }) {
                            Text("Previous")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(currentIndex > 0 ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(currentIndex == 0)
                        
                        Button(action: {
                            showNextCard()
                        }) {
                            Text("Next")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(currentIndex < flashcards.count - 1 ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(currentIndex == flashcards.count - 1)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .navigationTitle("Study Flashcards")
    }
    
    // Flip the flashcard to show back/front
    private func flipFlashcard() {
        showBack.toggle()
    }
    
    // Show the previous card
    private func showPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            showBack = false  // Reset to show front
        }
    }
    
    // Show the next card
    private func showNextCard() {
        if currentIndex < flashcards.count - 1 {
            currentIndex += 1
            showBack = false  // Reset to show front
        }
    }
}
