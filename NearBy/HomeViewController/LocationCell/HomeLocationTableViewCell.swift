//
//  HomeLocationTableViewCell.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import UIKit
import Kingfisher

class HomeLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    var venue : Venue? {
        didSet {
            guard let venue = self.venue else {
                self.resetUIElements()
                return
            }
            
            descriptionLabel.text = "\(getCategoriesString(categories: venue.categories)) - \(venue.address ?? "no address")"
            mainLabel.text = venue.name
            
            if let imageLink = venue.imageLink {
                self.setImage(urlString: imageLink)
            } else {
                self.getAndSetImage(of: venue)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationImageView.kf.indicatorType = .activity
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCategoriesString(categories : [String]) -> String {
        
        var returnedCategoriesString = ""
        
        for (index, category) in categories.enumerated() {
            returnedCategoriesString += category
            
            if index + 1 != categories.count {
                returnedCategoriesString += ", "
            }
        }
        
        return returnedCategoriesString
    }
    
    func setImage(urlString : String) {
        if let url = URL.init(string: urlString) {
            locationImageView.kf.setImage(with: url)
        }
    }
    
    func getAndSetImage(of venue: Venue) {
        
        nearbyProvider.request(.getImage(venueID: venue.id)) {[weak self] (result) in
            switch result {
            case .success(let response):
                
                if let json = try? response.mapJSON() as? [String:Any] {
                    if let response = json["response"] as? [String:Any] {
                        if let photos = response["photos"] as? [String:Any] {
                            if let items = photos["items"] as? [[String:Any]], let firstItem = items.first {
                                let prefix = firstItem["prefix"] as! String
                                let width = firstItem["width"] as! Int
                                let height = firstItem["height"] as! Int
                                let suffix = firstItem["suffix"] as! String
                                
                                let urlString = "\(prefix)\(width)x\(height)\(suffix)"
                                print(urlString)
                                venue.imageLink = urlString
                                self?.setImage(urlString: urlString)
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func resetUIElements() {
        descriptionLabel.text = ""
        mainLabel.text = ""
        locationImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetUIElements()
    }

}
