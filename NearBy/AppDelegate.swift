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
        
        self.checkForLocationsRefreshMethod()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LocationService.shared.stopMonitoringSignificantChangeInLocation()
        //left intentionally to stop location service as we do not want it to run in the background
    }
    
    private func checkForLocationsRefreshMethod() {
        //default is realtime
        if LocationsRefreshMethodManager.shared.currentRefreshMethod == .none {
            LocationsRefreshMethodManager.shared.setRefreshMethod(with: .realtime)
        }
    }

}

