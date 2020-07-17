//
//  Extensions.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

var AssociatedObjectHandle: UInt8 = 0

extension UIView {

    func startProgressAnim() {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin)
        activityIndicatorView.color = .black
        
        let label = UILabel(frame: .zero)
        label.text = "Please wait..."
        label.sizeToFit()
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [activityIndicatorView, label])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.stringTag = Constants.indicatorView
        
        self.addSubview(stackView)
        self.bringSubviewToFront(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        activityIndicatorView.startAnimating()
    }
    
    func stopProgressAnim() {
        
        if let view = self.subviews.filter({ $0.stringTag == Constants.indicatorView }).first {
            view.removeFromSuperview()
        }
        
//        for view in self.subviews {
//            if let activityView = view as? NVActivityIndicatorView {
//                activityView.stopAnimating()
//                activityView.removeFromSuperview()
//                break
//            }
//        }
    }
    
    
    func pinEdgesToSuperviewBounds(margin: CGFloat = 0) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `pinEdgesToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: margin).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margin).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margin).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margin).isActive = true
        
    }
    
    var stringTag:String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let didChangeLocationsRefreshMethod = Notification.Name("didChangeLocationsRefreshMethod")
}
