//
//  UNService.swift
//  LocalNotification
//
//  Created by Adarsha Upadhya on 20/01/19.
//  Copyright © 2019 Adarsha Upadhya. All rights reserved.
//

import Foundation
import UserNotifications

class UNService:NSObject {
    
    static let shared = UNService()
    
    private override init(){}
    let uncenter = UNUserNotificationCenter.current()
    
    func authorize(){
        
        let options:UNAuthorizationOptions = [.alert,.badge,.sound,.carPlay]
        
        uncenter.requestAuthorization(options: options) { (grant, error) in
            print("Error:\(error?.localizedDescription)")
            guard grant else{
                print("User denied access")
                return
            }
            
            self.configure()
        }
        
        
    }
    
    func configure(){
        uncenter.delegate = self
        self.setupCategories()
    }
    
    func setupCategories(){
        
        
        
        let timerAction = UNNotificationAction(identifier: UNNotificationActionType.Timer.rawValue, title: "Trigger", options: UNNotificationActionOptions.authenticationRequired)
        
        let dateAction = UNNotificationAction(identifier: UNNotificationActionType.Date.rawValue, title: "Date Send", options: UNNotificationActionOptions.destructive)
        
         let locationAction = UNNotificationAction(identifier: UNNotificationActionType.Location.rawValue, title: "Location Send", options: UNNotificationActionOptions.foreground)
        
        
        
        let timerCategory = UNNotificationCategory(identifier: UNNotificationCategoryType.Timer.rawValue, actions: [timerAction], intentIdentifiers: [])
        
        let dateCategory = UNNotificationCategory(identifier: UNNotificationCategoryType.Date.rawValue, actions: [dateAction], intentIdentifiers: [])
        
        let locationCategory = UNNotificationCategory(identifier: UNNotificationCategoryType.Location.rawValue, actions: [locationAction], intentIdentifiers: [])
        
        uncenter.setNotificationCategories([timerCategory,dateCategory,locationCategory])
        
    }
    
    
    
    func timerRequest(interval:TimeInterval){
        
        let content = UNMutableNotificationContent()
        content.body = "Yeh Your time is up.. come on."
        content.badge = 1
        content.sound = .default
        content.title = "Timer is UP"
        content.categoryIdentifier = UNNotificationCategoryType.Timer.rawValue
        if let attachement = self.getAttachment(for: .Timer){
            content.attachments = [attachement]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let request:UNNotificationRequest = UNNotificationRequest(identifier: "user.timer", content: content, trigger: trigger)
        
        uncenter.add(request, withCompletionHandler: nil)
        
    }
    
    
    func dateRequest(datecomponents:DateComponents){
        
        let content = UNMutableNotificationContent()
        content.body = "Yeh Your time is up.. come on."
        content.badge = 1
        content.sound = .default
        content.title = "Date is UP"
        content.categoryIdentifier = UNNotificationCategoryType.Date.rawValue
        
        if let attachement = self.getAttachment(for: .Date){
            content.attachments = [attachement]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
        let request = UNNotificationRequest(identifier: "user.date", content: content, trigger: trigger)
        
        uncenter.add(request, withCompletionHandler: nil)
        
    }
    
    func locationRequest(){
        let content = UNMutableNotificationContent()
        content.body = "Yeh Your time is up.. come on."
        content.badge = 1
        content.sound = .default
        content.title = "You got it welcome back"
        content.categoryIdentifier = UNNotificationCategoryType.Location.rawValue
        
        if let attachement = self.getAttachment(for: .Location){
            content.attachments = [attachement]
        }
        
        let request = UNNotificationRequest(identifier: "user.location", content: content, trigger: nil)
        uncenter.add(request, withCompletionHandler: nil)
    }
    
    
    func getAttachment(for id:NotificationAttachementType)->UNNotificationAttachment?{
        
        var imageName:String
        
        switch id {
            
        case .Date:
            imageName =  "DateAlert"
            
        case .Timer:
            imageName = "TimeAlert"
            
        case .Location:
            imageName = "LocationAlert"
            
        }
        
        guard let attachement = Bundle.main.url(forResource: imageName, withExtension: "png") else{ return nil}
        
        do{
            return try UNNotificationAttachment(identifier: id.rawValue, url: attachement, options: nil)
        
            
        }catch{
            return nil
        }
    }
    
}


extension UNService:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Response came and hadled")
        
        
        guard let actionId = UNNotificationActionType(rawValue: response.actionIdentifier) else { return }
        NotificationCenter.default.post(name: Notification.Name("localNoification.action"), object: actionId)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            print("UNwill present")
        let options:UNNotificationPresentationOptions = [.sound,.alert]
        completionHandler(options)
    }
}
