//
//  AppDelegate.swift
//  TopicRun
//
//  Created by 조성산 on 2022/07/18.
//

import UIKit
import HealthKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var healthStore : HKHealthStore!;
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 건강 데이터 수집 관련 권한 설정
        authorization { (success, healthkit) in
            self.healthStore =  healthkit;
            if(success){
                
                // Watch Connectivity 세션 사용 가능 여부 확인
                if !SessionHandler.shared.isSupported() {
                    print("WCSession not supported")
                }
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

