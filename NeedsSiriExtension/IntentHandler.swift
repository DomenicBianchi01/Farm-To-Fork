//
//  IntentHandler.swift
//  NeedsSiriExtension
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Intents

final class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any? {
        return self
    }
}

// MARK: - INSearchForNotebookItemsIntentHandling
extension IntentHandler: INSearchForNotebookItemsIntentHandling {
    func handle(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
        print(intent)
        
        guard let locationId = UserDefaults.standard.string(forKey: Constants.preferredLocationId) else {
            completion(INSearchForNotebookItemsIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        /*NeedsService().fetchNeeds(forLocation: locationId) { result in
            
        }*/
        
        let response = INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil)
        response.notes = [INNote(title: INSpeakableString(spokenPhrase: "Test"), contents: [], groupName: INSpeakableString(spokenPhrase: "Urgent Needs"), createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil),
        INNote(title: INSpeakableString(spokenPhrase: "Test2"), contents: [], groupName: INSpeakableString(spokenPhrase: "Urgent Needs"), createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil),
        INNote(title: INSpeakableString(spokenPhrase: "Test3"), contents: [], groupName: INSpeakableString(spokenPhrase: "Urgent Needs"), createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)]

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completion(response)
        }
    }
}

