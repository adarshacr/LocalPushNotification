//
//  CLService.swift
//  LocalNotification
//
//  Created by Adarsha Upadhya on 20/01/19.
//  Copyright © 2019 Adarsha Upadhya. All rights reserved.
//

import Foundation
import CoreLocation


class CLService:NSObject{
    
    static let shared = CLService()
    private override init(){
        
    }
    var locationManager = CLLocationManager()
    var shouldSetRegion = true
    func authorize(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    func updateLocation(){
        shouldSetRegion = true
        locationManager.startUpdatingLocation()
    }
}

extension CLService:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locations = locations.first , shouldSetRegion else {return}
        shouldSetRegion = false
        let region = CLCircularRegion(center: locations.coordinate, radius: 20, identifier: "user.region")
        manager.startMonitoring(for: region)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NotificationCenter.default.post(name: Notification.Name("region.notification"), object: nil)
    }
    
}
