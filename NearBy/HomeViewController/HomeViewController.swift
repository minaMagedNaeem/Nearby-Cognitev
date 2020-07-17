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
            
            theTableView.tableFooterView = UIView(frame: .zero)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationsRefreshMethodChange(Notification:)), name: .didChangeLocationsRefreshMethod, object: nil)
        
        self.changeMethodButtonTitle()
        
        self.handleLocationService()
        
        //self.loadData(withCoordinate: 40.7243, lng: -74.0018)
        
        
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
        
        theTableView.backgroundView = nil
        self.view.startProgressAnim()
        
        nearbyProvider.request(.getLocations(latitude: lat, longitude: lng)) {[weak self] (result) in
            self?.view.stopProgressAnim()
            
            switch result {
            case .success(let response):
                
                guard let json = try? response.mapJSON() as? [String:Any] else {
                    self?.showErrorView(type: .noData)
                    return
                }
                
                print(json)
                
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.showErrorView(type: .networkError)
            }
        }
    }
    
    func showErrorView(type: AlertViewType) {
        theTableView.backgroundView = EmptyView.getAlertView(state: type)
    }

    @IBAction func didPressLocationsRefreshButton(_ sender: Any) {
        
        if LocationsRefreshMethodManager.shared.currentRefreshMethod == .realtime {
            LocationsRefreshMethodManager.shared.setRefreshMethod(with: .singleUpdate)
        } else {
            LocationsRefreshMethodManager.shared.setRefreshMethod(with: .realtime)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

