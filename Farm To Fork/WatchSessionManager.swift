//
//  WatchSessionManager.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-22.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import WatchConnectivity

final class WatchSessionManager: NSObject {
    // MARK: - Shared Instances
    static let shared = WatchSessionManager()
    private let session = WCSession.default
    
    // MARK: - Lifecycle Functions
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            if session.activationState == .notActivated {
                session.activate()
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /**
     Send a message (request) to the iOS app. For example, send a message to the iOS app so it can return data from the UserDefaults app group that it has access to.
     
     - parameter data: A dictionary of data to send to the iOS app that it can use to execute the request.
    */
    func sendMessage(with data: [String : Any], and completion: @escaping ((Result<[String : Any]>) -> Void)) {
        guard session.activationState == .activated else {
            completion(.error(NSError(domain: "Cannot communicate between watch and iOS app.", code: 0, userInfo: nil)))
            return
        }
        session.sendMessage(data, replyHandler: { result in
            completion(.success(result))
        }, errorHandler: { error in
            completion(.error(error))
        })
    }
}

// MARK: WCSessionDelegate
extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard UserDefaults.appGroup?.string(forKey: Constants.passwordSaved) != nil else {
            replyHandler([Constants.error : "Please login on the iOS app first"])
            return
        }
        
        if message[Constants.preferredLocationId] != nil, let preferredLocation = UserDefaults.appGroup?.object(forKey: Constants.preferredLocationId) as? Int {
            replyHandler([Constants.preferredLocationId : preferredLocation])
        } else if let preferredLocationId = message[Constants.setPreferredLocationId] as? Int, let preferredLocationName = message[Constants.setPreferredLocationName] as? String {
            UserDefaults.appGroup?.set(preferredLocationId, forKey: Constants.preferredLocationId)
            UserDefaults.appGroup?.set(preferredLocationName, forKey: Constants.preferredLocationName)
            //Nothing to send back
            replyHandler([:])
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
