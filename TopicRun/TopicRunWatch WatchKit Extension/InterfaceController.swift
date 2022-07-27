//
//  InterfaceController.swift
//  TopicRunWatch WatchKit Extension
//
//  Created by Shin yongjun on 2022/07/20.
//
import Foundation
import WatchKit
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var sceneInterface: WKInterfaceSKScene!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    // WCSession 프로퍼티 선언
    private var session = WCSession.default
    
    // HealthKit 관련 프로퍼티 선언
    var heartRateValue: Double?
    var heartRateQuery : HKObserverQuery! = nil
    var healthStore : HKHealthStore!;
    var workSession: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    
    // WorkOut 진행중 여부 플래그
    var workOutFlag = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        runWorkOut()
        receiveMessage()
    }
    
    
    override func willActivate() {
        super.willActivate()
        
        // WCSesssion 초기화, InterfaceController를 Delegate로 지정
        if isSupported() {
            session.delegate = self
            session.activate()
        }
        
        receiveMessage()
    }
    
    
    override func didDeactivate() {
        super.didDeactivate()

        receiveMessage()
    }
    
    
// MARK: - 가장 최근의 HeartRate로 Label update (Counting.. -> ~BPM)
    private func updateLabel(statistics: HKStatistics?) {
        guard  let statistics = statistics else {
            return
        }
        DispatchQueue.main.async {
            
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            self.heartRateValue = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
            self.heartRateLabel.setText("\(Int(self.heartRateValue!)) BPM")

            
            // 3: Session property를 통해 communicatoin 메소드 구현, counterpart(iPhone)의 응답 관리
            if self.isReachable() {
                do {
                    print(self.heartRateValue)
                    try self.session.updateApplicationContext(["request":self.heartRateValue ?? "- -"])
                } catch {
                    print("error")
                }
            } else {
                print("iPhone is not reachable…!")
            }
        }
    }
    
    
// MARK: - WorkOut 세션 시작 / 종료 함수
    private func runWorkOut() {
        authorization { (success, healthkit) in
            
            self.healthStore =  healthkit;
            if(success){
                
                // WorkOut 세션 활용
                let configuration = HKWorkoutConfiguration()
                configuration.activityType = .running
                configuration.locationType = .outdoor
                
                do {
                    // WorkOut 세션 선언 후
                    self.workSession = try HKWorkoutSession(healthStore: self.healthStore, configuration: configuration)
                    self.builder = self.workSession.associatedWorkoutBuilder()
                } catch {
                    self.dismiss()
                    return
                }
                self.workSession.delegate = self
                self.builder.delegate = self
                
                // WorkOut 세션의 데이터 주기적으로 전달 선언
                self.builder.dataSource = HKLiveWorkoutDataSource(healthStore: self.healthStore,
                                                                  workoutConfiguration: configuration)
                self.workSession.startActivity(with: Date())
                self.builder.beginCollection(withStart: Date()) { (success, error) in
                    
                }
            }
            
        }
    }
    
    
    private func stopWorkOut() {
        if((workSession) != nil){
            workSession.end()

            builder.endCollection(withEnd: Date()) { (success, error) in
                self.builder.finishWorkout { (workout, error) in
                    
                }
            }
        }
    }
    

// MARK: - iPhone에서 WorkOut 세션 시작 / 종료 명령 메시지 수신
    private func receiveMessage() {
        if WCSession.isSupported() {
            if let sendedWord = WCSession.default.receivedApplicationContext["action"] as? String {
                print(sendedWord)
                if sendedWord == "start" && !workOutFlag{
                    runWorkOut()
                    workOutFlag = true
                } else if sendedWord == "stop" {
                    stopWorkOut()
                    workOutFlag = false
                } else {
                    print("No Action Type")
                }
            }
        } else {
            print("error")
        }
    }

    
// MARK: - Counterpart app이 message사용이 가능한지 확인
    
    private func isSupported() -> Bool {
        return WCSession.isSupported()
    }
    
    
    private func isReachable() -> Bool {
        return session.isReachable
    }

}


// MARK: - Watch Connectivity Session Delegate
extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error: \(String(describing: error))")
    }
}


// MARK: - Workout Builder Delegate
extension InterfaceController: HKLiveWorkoutBuilderDelegate {
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


// MARK: - Workout Session  Delegate
extension InterfaceController: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
    }
    
    func handle(_ workoutConfiguration: HKWorkoutConfiguration){
        print("start");
    }
    
    
}
