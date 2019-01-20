//
//  AlertService.swift
//  LocalNotification
//
//  Created by Adarsha Upadhya on 20/01/19.
//  Copyright © 2019 Adarsha Upadhya. All rights reserved.
//

import UIKit

class AlertService{

  //  static let shared = AlertService()
    
    private init(){}

    
    static func actionSheet(in vc:ViewController, title:String,completionHandler:@escaping()->Void){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        vc.present(alert, animated: true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                vc.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
}
