//
//  HeartKitAutorization.swift
//  TopicRunWatch WatchKit Extension
//
//  Created by DongKyu Kim on 2022/07/20.
//

import Foundation
import HealthKit

// MARK: - 건강데이터 수집 권한 설정
func authorization(completion:@escaping (Bool ,HKHealthStore) -> Void ){
    
    let healthStore = HKHealthStore();
    let typesToShare: Set = [
        HKQuantityType.workoutType()
    ]
    let typesToRead: Set = [
        HKQuantityType.quantityType(forIdentifier: .heartRate)!
    ]
    
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (sucess, error) in
        
        if((error) != nil){
            print("authorization error: \(error!)");
            return;
        }
        
        completion(sucess,healthStore);
        
    }
}
