//
//  HomeViewController.swift
//  NearBy
//
//  Created by Mina Maged on 7/17/20.
//  Copyright © 2020 Mina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var locationsRefreshButton: UIBarButtonItem!
    
    @IBOutlet weak var theTableView : UITableView! {
        didSet {
            theTableView.delegate = self
            theTableView.dataSource = self
            
            theTableView.tableFooterView = UIView(frame: .zero) //put to disable cell separators when tableview is empty
        }
    }
    
    var venues : [Venue] = [] {
        didSet {
            if venues.count == 0 {
                self.showErrorView(type: .noData)
            } else {
                self.removeErrorView()
            }
            self.theTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationsRefreshMethodChange(Notification:)), name: .didChangeLocationsRefreshMethod, object: nil)
        
        self.changeMethodButtonTitle()
        
        self.handleLocationService()
        
    }
    
    @objc func handleLocationsRefreshMethodChange(Notification: NSNotification) {
        print("method changed to \(LocationsRefreshMethodManager.shared.currentRefreshMethod.rawValue)")
        
        self.changeMethodButtonTitle()
        self.handleLocationService()
    }
    
    func handleLocationService() {
        switch LocationsRefreshMethodManager.shared.currentRefreshMethod {
            
        case .realtime:
            LocationService.shared.subscribeToSignificantChangeInLocation { [weak self] (lat, lng) in
                self?.loadData(withCoordinate: lat, lng: lng)
            }
        case .singleUpdate:
            LocationService.shared.stopMonitoringSignificantChangeInLocation()
            LocationService.shared.getLocation(success: { [weak self] (lat, lng) in
                self?.loadData(withCoordinate: lat, lng: lng)
            }) { [weak self] in
                self?.showErrorView(type: .networkError)
            }
        case .none:
            print("do nothing")
        }
    }
    
    func changeMethodButtonTitle() {
        switch LocationsRefreshMethodManager.shared.currentRefreshMethod {
            
        case .realtime:
            locationsRefreshButton.title = "Realtime"
        case .singleUpdate:
            locationsRefreshButton.title = "Single Update"
        case .none:
            locationsRefreshButton.title = "None"
        }
    }
    
    func loadData(withCoordinate lat: Double, lng: Double) {
        
        self.removeErrorView()
        self.view.startProgressAnim()
        
        nearbyProvider.request(.getLocations(latitude: lat, longitude: lng)) {[weak self] (result) in
            self?.view.stopProgressAnim()
            
            switch result {
            case .success(let response):
                
                guard let json = try? response.mapJSON() as? [String:Any] else {
                    self?.showErrorView(type: .networkError)
                    return
                }
                
                print(json)
                
                var venuesToBeSet : [Venue] = []
                
                if let response = json["response"] as? [String:Any] {
                    if let groups = response["groups"] as? [[String:Any]] {
                        for group in groups {
                            if let items = group["items"] as? [[String:Any]] {
                                for item in items {
                                    if let venueDict = item["venue"] as? [String:Any] {
                                        venuesToBeSet.append(Venue.init(venueDict: venueDict))
                                    }
                                }
                            }
                        }
                    }
                }
                
                print(venuesToBeSet)
                self?.venues = venuesToBeSet
                
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.showErrorView(type: .networkError)
            }
        }
    }
    
    func showErrorView(type: AlertViewType) {
        theTableView.backgroundView = EmptyView.getAlertView(state: type)
    }
    
    func removeErrorView() {
        theTableView.backgroundView = nil
    }

    @IBAction func didPressLocationsRefreshButton(_ sender: Any) {
        
        if LocationsRefreshMethodManager.shared.currentRefreshMethod == .realtime {
            LocationsRefreshMethodManager.shared.setRefreshMethod(with: .singleUpdate)
        } else {
            LocationsRefreshMethodManager.shared.setRefreshMethod(with: .realtime)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeLocationTableViewCell
        cell.venue = venues[indexPath.row]
        
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

