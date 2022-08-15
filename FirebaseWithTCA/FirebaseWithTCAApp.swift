//
//  FirebaseWithTCAApp.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import SwiftUI
import UIKit
import CombineSchedulers

@main
struct FirebaseWithTCAApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: .init(),
                                     reducer: contentReducer,
                                     environment: .live))
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, FUIAuthDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = [
            FUIGoogleAuth(authUI: FUIAuth.defaultAuthUI()!),
            FUIOAuth.appleAuthProvider(),
            FUIFacebookAuth(authUI: FUIAuth.defaultAuthUI()!),
        ]
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

struct Environment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var authClient: AuthClient
}

extension Environment {
    static let live = Environment(
        mainQueue: .main,
        authClient: .live
    )
}
