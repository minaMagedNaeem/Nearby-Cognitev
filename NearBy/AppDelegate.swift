//
//  AppDelegate.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //self.checkForLocationsRefreshMethod()
        
        return true
    }
    
    private func checkForLocationsRefreshMethod() {
        if LocationsRefreshMethodManager.shared.currentRefreshMethod == .none {
            LocationsRefreshMethodManager.shared.setRefreshMethod(with: .realtime)
        }
    }

}

