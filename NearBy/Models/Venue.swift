//
//  Venue.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import Foundation

class Venue {
    
    var id : String
    var name : String
    var categories : [String]
    var address : String?
    var imageLink : String?
    
    init(id: String, name: String, categories: [String], address: String, imageLink: String?) {
        self.id = id
        self.name = name
        self.categories = categories
        self.address = address
        self.imageLink = imageLink
    }
    
    init(venueDict: [String:Any]) {
        self.id = venueDict["id"] as! String
        self.name = venueDict["name"] as! String
        
        var categoriesToBeSet : [String] = []
        
        if let categories = venueDict["categories"] as? [[String:Any]] {
            for category in categories {
                if let categoryName = category["name"] as? String {
                    categoriesToBeSet.append(categoryName)
                }
            }
        }
        
        self.categories = categoriesToBeSet
        
        if let location = venueDict["location"] as? [String:Any], let addressToBeSet = location["address"] as? String {
            self.address = addressToBeSet
        }
    }
    
}
