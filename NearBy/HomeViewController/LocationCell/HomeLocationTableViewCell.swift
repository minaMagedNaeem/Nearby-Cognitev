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
            
            descriptionLabel.text = "\(getCategoriesString(categories: venue.categories)) - \(venue.address)"
            mainLabel.text = venue.name
            
            
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
    
    func setImage(of venue: Venue) {
        //MARK: - Get image here
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
