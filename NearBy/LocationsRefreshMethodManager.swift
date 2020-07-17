//
//  LocationsRefreshMethodManager.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import Foundation

class LocationsRefreshMethodManager {
    
    public static var shared = LocationsRefreshMethodManager()
    
    var currentRefreshMethod : UserLocationsRefreshMethod {
        return UserLocationsRefreshMethod(rawValue: UserDefaults.standard.string(forKey: Constants.locationsRefreshMethod) ?? "") ?? .none
    }
    
    private init() {}
    
    func setRefreshMethod(with newMethod: UserLocationsRefreshMethod) {
        UserDefaults.standard.set(newMethod.rawValue, forKey: Constants.locationsRefreshMethod)
        NotificationCenter.default.post(name: .didChangeLocationsRefreshMethod, object: nil)
    }
    
}
