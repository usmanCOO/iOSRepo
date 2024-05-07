//
//  AppDelegate.swift
//  DealDoc
//
//  Created by Asad Khan on 9/16/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SwiftyStoreKit
//import CocoaLumberjack
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var userResponse :LoginResponse?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
       // setupLogging()
        // Override point for customization after application launch.
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                         
                         for purchase in purchases {
                             switch purchase.transaction.transactionState {
                             case .purchased, .restored:
                                 let downloads = purchase.transaction.downloads
                                 if !downloads.isEmpty {
                                     SwiftyStoreKit.start(downloads)
                                 } else if purchase.needsFinishTransaction {
                                     // Deliver content from server, then:
                                     SwiftyStoreKit.finishTransaction(purchase.transaction)
                                 }
                                 print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                             case .failed, .purchasing, .deferred:
                                 break // do nothing
                             @unknown default:
                                 break // do nothing
                             }
                         }
                     }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func setupLogging() {
//       DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
//       let fileLogger: DDFileLogger = DDFileLogger() // File Logger
//       fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
//       fileLogger.logFileManager.maximumNumberOfLogFiles = 7
//       DDLog.add(fileLogger)
//    }

//    func writeLog(message: String) {
//       DDLogDebug(message)
//    }


}

