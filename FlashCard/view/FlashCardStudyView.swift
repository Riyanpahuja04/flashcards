//
//  FlashCardStudyView.swift
//  FlashCard
//
//  Created by Riyan Pahuja on 13/10/2024.
//

import SwiftUI

struct FlashcardStudyView: View {
    var flashcards: [FlashcardDataModel]  // Pass the Firestore flashcards
    @State private var currentIndex = 0
    @State private var showBack = false
    
    var body: some View {
        VStack {
            if flashcards.isEmpty {
                Text("No flashcards available")
                    .font(.headline)
            } else {
                VStack {
                    Text(showBack ? flashcards[currentIndex].backText : flashcards[currentIndex].frontText)
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
    
    private func flipFlashcard() {
        showBack.toggle()
    }
    
    private func showPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            showBack = false
        }
    }
    
    private func showNextCard() {
        if currentIndex < flashcards.count - 1 {
            currentIndex += 1
            showBack = false
        }
    }
}
