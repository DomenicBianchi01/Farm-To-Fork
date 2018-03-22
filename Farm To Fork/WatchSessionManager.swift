//
//  WatchSessionManager.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-22.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject {
    // MARK: - Shared Instances
    static let shared = WatchSessionManager()
    
    // MARK: - Lifecycle Functions
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            if WCSession.default.activationState == .notActivated {
                WCSession.default.activate()
            }
        }
    }
    
    // MARK: - Helper Functions
    func sendMessage(with completion: @escaping ((Result<[String : Any]>) -> Void)) {
        WCSession.default.sendMessage([Constants.preferredLocationId : "getValue"], replyHandler: { result in
            completion(.success(result))
        }, errorHandler: { error in
            completion(.error(error))
        })
    }
}

// MARK: WCSessionDelegate
extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message[Constants.preferredLocationId] != nil, let preferredLocation = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId) {
            replyHandler([Constants.preferredLocationId : preferredLocation])
        } else {
            replyHandler([:])
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { /* Not used */ }
    
    // Delegate functions required only for iOS
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { /* Not used */ }
    func sessionDidDeactivate(_ session: WCSession) { /* Not used */ }
    #endif
}
