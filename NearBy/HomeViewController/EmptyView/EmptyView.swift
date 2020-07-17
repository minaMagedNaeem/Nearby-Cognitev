//
//  EmptyView.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    var alertState : AlertViewType! {
        didSet {
            switch alertState {
            case .networkError:
                alertImageView.image = #imageLiteral(resourceName: "something_wrong")
                alertLabel.text = "No data found!"
            case .noData:
                alertImageView.image = #imageLiteral(resourceName: "alert")
                alertLabel.text = "Something went wrong!"
            case .none:
                alertImageView.image = nil
                alertLabel.text = ""
            }
        }
    }
    
    class func instanceFromNib() -> EmptyView {
        return UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyView
    }
    
    static func getAlertView(state: AlertViewType) -> EmptyView {
        
        let alertView = EmptyView.instanceFromNib()
        alertView.alertState = state
        
        return alertView
    }

}
