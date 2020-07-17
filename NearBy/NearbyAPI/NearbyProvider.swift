//
//  NearbyProvider.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import Foundation
import Moya
import Result

enum NearbyAPI : TargetType {
    
    case getLocations(latitude: Double, longitude: Double)
    
    public var baseURL: URL {
        return URL.init(string: "https://api.foursquare.com/v2")!
    }

    public var path: String {
        switch self {
        case .getLocations:
            return "/venues/explore"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getLocations:
            return .get
        }
    }

    public var sampleData: Data {
      return Data()
    }

    public var task: Task {
        switch self {
        case .getLocations(let latitude, let longitude):
            let clientID = Constants.CLIENT_ID
            let clientSecret = Constants.CLIENT_SECRET
            let radius = Constants.RADIUS
            
            let versioning = self.getVersioning()
            //40.7243, lng: -74.0018
            return .requestParameters(parameters: ["client_id":clientID, "client_secret":clientSecret, "v":versioning, "radius":radius, "sortByDistance":1, "ll":"\(40.7243),\(-74.0018)"], encoding: URLEncoding.default)
        }
    }
    
    public var isSilent : Bool {
        switch self {
        case .getLocations:
            return true
        }
    }

    public var headers: [String: String]? {
        let headers : [String:String] = [:]
        
        switch self {
        case .getLocations:
            return headers
        }
    }

    public var validationType: ValidationType {
      return .successCodes
    }
    
    func getVersioning() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.string(from: date)
        
        let components = result.split(separator: ".")
        
        let day = components[0]
        let month = components[1]
        let year = components[2]
        
        return "\(year)\(month)\(day)"
    }
    
}

final class ErrorHandlerPlugin : PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        //Note: Do not care
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if (target as! NearbyAPI).isSilent {
            return
        }
        
        guard case Result.failure(let error) = result else { return }
        
        UIApplication.topViewController()?.displayAlert(title: "Webservice error", message: "\(error.localizedDescription)")
    }
}

let nearbyProvider = MoyaProvider<NearbyAPI>.init(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true), ErrorHandlerPlugin()])
