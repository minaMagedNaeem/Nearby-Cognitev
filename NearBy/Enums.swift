//
//  Enums.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import Foundation

enum UserLocationsRefreshMethod : String {
    case realtime = "realtime"
    case singleUpdate = "singleUpdate"
    case none
}

enum AlertViewType {
    case networkError
    case noData
}
