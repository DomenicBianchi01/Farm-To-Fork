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

        guard let locationId = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId) else {
            completion(INSearchForNotebookItemsIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
            return
        }
        
        NeedsService().fetchNeeds(forLocation: locationId) { result in
            switch result {
            case .success(let needs):
                let response = INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil)
                var notes: [INNote] = []
                for need in needs {
                    notes.append(INNote(title: INSpeakableString(spokenPhrase: need.name),
                        contents: [INTextNoteContent(text: "\(need.targetQuantity - need.currentQuantity) more pledges needed!")],
                        groupName: INSpeakableString(spokenPhrase: "Urgent Needs"),
                        createdDateComponents: nil,
                        modifiedDateComponents: nil, identifier: nil))
                }
                response.notes = notes
                completion(response)
            case .error:
                completion(INSearchForNotebookItemsIntentResponse(code: .failure, userActivity: nil))
            }
        }
    }
}
