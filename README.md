# Flashcard iOS App

A flashcard application for iOS that helps users create, save, and study flashcard decks. Users can create their own decks, save decks from the marketplace, and study individual flashcards. The app uses **Core Data** for local storage and **Firebase Firestore** for cloud-based marketplace decks.

## Features

- **Create Decks**: Users can create custom flashcard decks locally.
- **Marketplace**: Browse and save decks from the online marketplace (Firebase Firestore).
- **Study Flashcards**: Flip through flashcards to study topics, using a clean and intuitive interface.
- **Core Data Integration**: All user-created decks and saved decks are stored locally using Core Data.
- **Firebase Firestore Integration**: The app integrates with Firestore to fetch and save decks to the cloud.
  
## Screens

1. **Home Page**: Two tabs – "Your Decks" and "Marketplace". The "Your Decks" tab shows user-created or saved decks, and the "Marketplace" tab shows available decks from Firestore.
2. **Deck Detail View**: Shows all flashcards in a selected deck. Users can edit, delete, or study the flashcards.
3. **Study View**: A flashcard viewer allowing users to flip flashcards and move between them.
4. **Create Deck View**: A form allowing users to create a new deck by entering a deck name and description.

## Tech Stack

- **iOS**: Swift, SwiftUI
- **Persistence**: Core Data
- **Cloud Storage**: Firebase Firestore

## Requirements

- iOS 14.0+
- Xcode 12+
- A Firebase project with Firestore configured

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/flashcard-ios-app.git
cd flashcard-ios-app
```

### 2. Set Up Firebase

- Go to the [Firebase Console](https://console.firebase.google.com/), create a project, and configure Firestore.
- Download the `GoogleService-Info.plist` file from your Firebase project and add it to your Xcode project.
  
### 3. Install Dependencies

Make sure your Firebase dependencies are included in your `Podfile`. If you haven’t installed Firebase yet, you can do so by adding the following lines to your `Podfile`:

```ruby
pod 'Firebase/Core'
pod 'Firebase/Firestore'
```

After adding the dependencies, run:

```bash
pod install
```

### 4. Core Data Model Setup

Ensure that the Core Data model includes two entities: `Deck` and `FlashCard`.

- **Deck**:
  - `id`: UUID
  - `name`: String
  - `descriptionText`: String
  - `isUserCreated`: Boolean
  - `isUserSaved`: Boolean
  
- **FlashCard**:
  - `id`: UUID
  - `frontText`: String
  - `backText`: String
  - `createdDate`: Date
  - **Relationships**: A `to-one` relationship to `Deck` and a `to-many` relationship from `Deck`.

### 5. Running the App

Once Firebase is set up and dependencies are installed, open the `.xcworkspace` file and build the project using Xcode.

```bash
open FlashcardApp.xcworkspace
```

Make sure to build the project using **Xcode** on a physical device or simulator with iOS 14.0 or higher.

### 6. Firebase Firestore Rules

To ensure Firestore works correctly, modify your Firestore security rules as needed. Below is an example rule that allows public read access:

```plaintext
service cloud.firestore {
  match /databases/{database}/documents {
    match /marketPlaceDecks/{deckId} {
      allow read: if true;  // Public read access
      allow write: if request.auth != null;  // Write access for authenticated users only
      
      match /flashcards/{flashcardId} {
        allow read: if true;
        allow write: if request.auth != null;
      }
    }
  }
}
```

### 7. Data Upload (Optional)

To upload sample decks to Firestore, you can use the provided `production_ready_flashcards.json` file. You can also use the following Python script to upload the JSON data to Firestore.

```python
import firebase_admin
from firebase_admin import credentials, firestore
import json

# Initialize Firebase Admin SDK
def initialize_firebase():
    cred = credentials.Certificate('path/to/your/serviceAccountKey.json')
    firebase_admin.initialize_app(cred)

# Load JSON and upload data
def upload_to_firestore():
    with open('production_ready_flashcards.json', 'r') as file:
        data = json.load(file)
    
    db = firestore.client()
    for deck in data:
        deck_ref = db.collection('marketPlaceDecks').document(deck['id'])
        deck_ref.set({'name': deck['name'], 'description': deck['description']})
        
        for flashcard in deck['flashcards']:
            flashcard_ref = deck_ref.collection('flashcards').document(flashcard['id'])
            flashcard_ref.set({'frontText': flashcard['frontText'], 'backText': flashcard['backText']})

if __name__ == '__main__':
    initialize_firebase()
    upload_to_firestore()
```

## Project Structure

```
📁 FlashcardApp
├── 📁 Models
│   ├── Deck.swift
│   └── FlashCard.swift
├── 📁 Views
│   ├── HomePageView.swift
│   ├── YourDecksView.swift
│   ├── MarketPlaceView.swift
│   ├── DeckDetailView.swift
│   └── FlashcardStudyView.swift
├── 📁 CoreData
│   └── CoreDataStack.swift
├── 📁 Firebase
│   └── FirestoreManager.swift
└── 📁 Resources
    ├── GoogleService-Info.plist
    └── production_ready_flashcards.json
```

## Key Features

- **Core Data**: Fully integrated for local storage of decks and flashcards.
- **Firebase Firestore**: Cloud storage for decks available in the marketplace.
- **Create Decks**: Users can create decks with custom flashcards locally.
- **Bookmark Decks**: Save decks from the marketplace to "Your Decks."

## Contributing

If you would like to contribute, feel free to fork the repository and submit a pull request.

1. Fork the repository
2. Create a new feature branch
3. Commit your changes
4. Push to the branch
5. Submit a pull request

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
