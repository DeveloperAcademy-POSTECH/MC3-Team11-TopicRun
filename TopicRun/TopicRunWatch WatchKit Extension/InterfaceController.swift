//
//  InterfaceController.swift
//  TopicRunWatch WatchKit Extension
//
//  Created by Shin yongjun on 2022/07/20.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController, HKLiveWorkoutBuilderDelegate,HKWorkoutSessionDelegate {
    
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    var heartRateQuery : HKObserverQuery! = nil
    var healthStore : HKHealthStore!;
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
//    @IBOutlet weak var imageView: WKInterfaceImage!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    override func willActivate() {
        
//        imageView.setImageNamed("AnimateHeart");
//        imageView.startAnimatingWithImages(in:NSRange(location: 0, length: 38) , duration:3, repeatCount:0);
        
        super.willActivate()
        // 권한 설정 (Bool, HKStore) closure
        authorization { (success, healthkit) in
            
            self.healthStore =  healthkit;
            if(success){
                
                // WorkOut 세션 활용
                let configuration = HKWorkoutConfiguration()
                configuration.activityType = .running
                configuration.locationType = .outdoor
                
                do {
                    // WorkOut 세션 선언 후
                    self.session = try HKWorkoutSession(healthStore: self.healthStore, configuration: configuration)
                    self.builder = self.session.associatedWorkoutBuilder()
                } catch {
                    self.dismiss()
                    return
                }
                self.session.delegate = self
                self.builder.delegate = self
                
                // WorkOut 세션의 데이터 주기적으로 전달 선언
                self.builder.dataSource = HKLiveWorkoutDataSource(healthStore: self.healthStore,
                                                                  workoutConfiguration: configuration)
                
                self.session.startActivity(with: Date())
                self.builder.beginCollection(withStart: Date()) { (success, error) in
                    
                }
            }
            
        }
        
    }
    
    override func didDeactivate() {
        
        if((session) != nil){
            session.end()
            
            builder.endCollection(withEnd: Date()) { (success, error) in
                self.builder.finishWorkout { (workout, error) in
                    
                    super.didDeactivate();
                }
            }
        }
        
    }
    
    
    
    // MARK: - 가장 최근의 HeartRate로 Label update (Counting.. -> ~BPM)
    func updateLabel(statistics: HKStatistics?) {
        guard  let statistics = statistics else {
            return
        }
        DispatchQueue.main.async {
            
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
            
            self.heartRateLabel.setText("\(Int(value!)) BPM")
            
        }
    }
    
    
    var observeQuery: HKObserverQuery!
    
    // MARK: - Workout Session  Delegate
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    func handle(_ workoutConfiguration: HKWorkoutConfiguration){
        print("start");
    }
    
    
    // MARK: - Workout Builder  Delegate
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            updateLabel(statistics: statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
}
