//
//  ViewController.swift
//  LocalNotification
//
//  Created by Adarsha Upadhya on 20/01/19.
//  Copyright © 2019 Adarsha Upadhya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNService.shared.authorize()
        CLService.shared.authorize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterNotification), name: Notification.Name("region.notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReciveAction(_:)), name: Notification.Name("localNoification.action"), object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func didEnterNotification(){
    
        UNService.shared.locationRequest()
        
    }

    
    @objc func didReciveAction(_ sender:Notification){
        
        guard let sender = sender.object as? UNNotificationActionType else {return}
        
        switch sender {
        case .Date:
            print("date triggered")
        case .Location:
            print("location triggerd")
        case .Timer:
            print("timer triggered")
            
       }
    }

    @IBAction func timerAction(_ sender: Any) {
        AlertService.actionSheet(in: self, title: "5 sec") {
            UNService.shared.timerRequest(interval: 5)
        }
        
    }
    @IBAction func dateAction(_ sender: Any) {
        
        AlertService.actionSheet(in: self, title: "Date components") {
            var components = DateComponents()
            components.second = 0
            UNService.shared.dateRequest(datecomponents: components)
        }
        
    }
    
    
    @IBAction func locationAction(_ sender: Any) {
        AlertService.actionSheet(in: self, title: "location") {
            CLService.shared.updateLocation()
        }
    }
    
}

