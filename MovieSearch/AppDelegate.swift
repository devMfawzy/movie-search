//
//  AppDelegate.swift
//  MovieSearch
//
//  Created by Mohamed Fawzy on 4/25/20.
//  Copyright © 2020 fuzzix. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }
    
    /**
     customize application appearance
     */
    private func customizeAppearance() {
        UISearchBar.appearance().barTintColor = .systemBlue
    }
    
}

