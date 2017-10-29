//
//  VectorGen.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/29.
//  Copyright © 2017年 王翀. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import Foundation

/*class FirstViewController: UIViewController {
    let pedo = CMPedometer()
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let typestoRead = Set(
            [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
             HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.electrodermalActivity)!
            ]
        )
        
        let typestoShare = Set(
            [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
             HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.electrodermalActivity)!
            ]
        )
        
        healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
        //}
        
        //func getVector() -> Void{
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if (!launchedBefore) {  //!
            let now = Date()
            //let startOfNextDay = Calendar.current.startOfDay(for: Date(timeInterval: (86400), since: now))
            let startOfNextDay = Date(timeInterval: (86400 - 300), since: Calendar.current.startOfDay(for: now));
            
            let dataCheckTimer : Timer! = Timer(fire: startOfNextDay /*now*/, interval: 86400 /*5*/, repeats: true, block: { (Timer) in
                //check data
                var num = 0;
                let userDefaults = UserDefaults()
                var storedData = [[Double]]();
                if (launchedBefore) {
                    num = userDefaults.integer(forKey: "num");
                    for i in 1...num {
                        storedData[i] = userDefaults.array(forKey: String(i)) as! [Double];
                    }
                }
                
                
                let startOfDay = Calendar.current.startOfDay(for: now)
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                var dataOfToday = [Double]()
                
                //------------------fetch coremotion pedometer data---------------------
                if CMPedometer.isDistanceAvailable() {
                    let pedData: CMPedometerData?
                    //@escaping CMPedometerHandler(pedData, nil)
                    self.pedo.queryPedometerData(from: startOfDay, to: now, withHandler: { (pedData, nil) -> Void in
                        if let numberOfSteps = pedData?.numberOfSteps.intValue{
                            //NSLog("#steps: \(numberOfSteps)")
                            dataOfToday[0] = Double(numberOfSteps);
                        }
                        if let averagePace = pedData?.averageActivePace?.doubleValue{
                            //NSLog("pace: \(averagePace)")
                            dataOfToday[1] = averagePace;
                            
                        }
                        if let distData = pedData?.distance?.doubleValue{
                            //NSLog("dist: \(distData)")
                            dataOfToday[2] = distData;
                        }
                    })
                }
                
                //------------------fetch skin conductivity data------------------
                let skinCondQuantityType = HKQuantityType.quantityType(forIdentifier: .electrodermalActivity)!
                
                /* let now = Date()
                 let startOfDay = Calendar.current.startOfDay(for: now)
                 let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)*/
                
                let query = HKStatisticsQuery(quantityType: skinCondQuantityType, quantitySamplePredicate: predicate, options: .discreteAverage) { (_, result, error) in
                    
                    var resultCount = 0.0
                    
                    guard let result = result else {
                        print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                        //completion(resultCount)
                        return
                    }
                    
                    if let sum = result.sumQuantity() {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                    }
                    
                    dataOfToday[3] = resultCount;
                    //NSLog("skin: \(resultCount)")
                    
                    /*DispatchQueue.main.async {
                     completion(resultCount)
                     }*/
                }
                
                self.healthStore.execute(query)
                
                //------------------fetch
                
                //storedData.append(dataOfToday);
                
                userDefaults.set(num+1, forKey: "num");
                for i in 1...num {
                    userDefaults.set(storedData[i], forKey: String(i));
                }
                userDefaults.set(dataOfToday, forKey: String(num+1));
                
            })
            RunLoop.current.add(dataCheckTimer!, forMode: .defaultRunLoopMode)
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
        }
        
        /*        if (self.firstTime) {
         //
         
         var component = DateComponents()
         component.hour = 10
         component.minute = 12
         component.second = 00
         let fireTime = Calendar.current.date(from : component)
         
         //let diffComponents = Calendar.current.dateComponents(Set([Calendar.Component.hour,Calendar.Component.minute/*,Calendar.Component.second*/]), from: fireTime!)
         //if (diffComponents.hour!==0 && diffComponents.minute!==0 && diffComponents.second!==0){
         
         //}
         //RunLoop.current.add(dataCheckTimer!, forMode: .defaultRunLoopMode)
         
         }
         
         
         firstTime = false;    // LOG*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}*/
