//
//  AppDelegate.swift
//  TopicRun
//
//  Created by 조성산 on 2022/07/18.
//

import UIKit
import HealthKit
import CoreData
import WatchConnectivity
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer = CDModel()
    
    var healthStore : HKHealthStore!;
    var session = WCSession.default
    
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        // AppleWatch에 [WorkOut 세션 종료] 명령 메시지 전달
        do {
            try self.session.updateApplicationContext(["action": "stop"])
        } catch {
            print("error")
        }
    }
}

// MARK: CoreData class
class CDModel {
    
    let container : NSPersistentContainer
    
    @Published var savedEntities : [Info] = []
    
    init(){
        container = NSPersistentContainer(name: "CoreDataModel")
        
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                
                print("ERROR LOADING CORE DATA \(error)")
            } else {
                print(self.container.managedObjectModel.configurations)
                print("Success")
                print(description)
            }
        }
        fetchTopic()
    }
    
    func fetchTopic(){
        let request = NSFetchRequest<Info>(entityName: "Info")
        do{
            savedEntities = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Fetching. \(error)")
        }
    }

    func addTopic(keyword : String, topic : String, runtime : String){
        
        let topics = Info(context: container.viewContext)
        
        if keyword.isEmpty {
            topics.keyword = "No keyword"
        } else{
            topics.keyword = keyword

        }
        if topic.isEmpty{
            topics.topic = "No topic"
        } else{
            topics.topic = topic
        }
        if runtime.isEmpty {
            topics.runtimes = "00:00"
        } else{
            topics.runtimes = runtime
        }
        
        topics.date = .now
        topics.index = Int16(savedEntities.endIndex)
        
        saveData()
    }
    
    
    func saveData(){
        do {
            try container.viewContext.save()
            fetchTopic()
        }catch let error{
            print("Error Saving. \(error)")
        }
    }

    func deleteTopic(indexset : IndexSet){
        guard let index = indexset.first else {return}
        let entity = self.savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
}


