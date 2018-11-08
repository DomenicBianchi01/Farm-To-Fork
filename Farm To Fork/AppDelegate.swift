//
//  AppDelegate.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-02-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import Intents
import Valet

/// If a user is logged in, this property will contain the users details. If no user is logged in, this property will be `nil`
var loggedInUser: User? = nil

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = WallpaperWindow()

    // MARK: - Application Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Spin up the Watch session manager (calling shared will initialize an instance of the class)
        _ = WatchSessionManager.shared
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        // Attempt logout to invalidate the session
        AuthenticationService().logout { _ in }
    }
    
    // This function is used for Siri Shortcuts Handling
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Siri Shortcuts only available on iOS 12+
        guard #available(iOS 12.0, *), userActivity.userInfo?.contains(where: { $0.key.description == "EFPName" }) ?? false else {
            return false
        }
        
        if loggedInUser == nil, let username = Valet.F2FValet.string(forKey: Constants.username), let password = Valet.F2FValet.string(forKey: Constants.password) {
            AuthenticationService().login(email: username, password: password) { result in
                switch result {
                case .success(let user):
                    loggedInUser = user
                    self.displayNeeds()
                case .error:
                    break
                }
            }
        } else if loggedInUser != nil {
            displayNeeds()
        }

        return true
    }
    
    // MARK: - Private Helper Functions
    private func displayNeeds() {
        guard let currentController = UIApplication.topViewController() else {
            return
        }

        let needsNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "needsNavController")
        
        if let needsController = needsNavController.children.first as? NeedsViewController {
            needsController.viewModel.hideCloseButton = false
        }

        currentController.present(needsNavController, animated: true, completion: nil)
    }
}
