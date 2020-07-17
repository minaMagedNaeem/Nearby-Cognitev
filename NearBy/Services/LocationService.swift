//
//  LocationService.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import Foundation
import INTULocationManager

class LocationService {
    
    private init() {}
    
    public static var shared = LocationService()
    
    private let locationManager = INTULocationManager.sharedInstance()
    
    func getLocation(success: @escaping ((_ lat: Double, _ lng: Double) -> ()), failure: @escaping () -> ()) {
                 
        locationManager.requestLocation(withDesiredAccuracy: .block, timeout: 30, delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                                     
            if (status == INTULocationStatus.success) {
                print("currentLocation \(String(describing: currentLocation))")
                
                if let currentLocation = currentLocation {
                    success(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                } else {
                    failure()
                }
            } else {
                failure()
            }
        }
    }
    
}
