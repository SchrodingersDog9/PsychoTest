//
//  HeartRate.swift
//  calc
//
//  Created by 王翀 on 2017/10/28.
//  Copyright © 2017年 王翀. All rights reserved.
//

import Foundation
import HealthKit

class HeartRate{
    
    let healthStore = HKHealthStore()
    
    func getTodaysSteps(){
        //completion: @escaping (Double) -> Void) {
        
        if #available(iOS 11.0, *) {
            let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
/*        } else {
            // Fallback on earlier versions
        }*/
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let endOfCount = NSDate()
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        //if #available(iOS 11.0, *) {
            let query = HKStatisticsQuery(quantityType:heartRateQuantityType, quantitySamplePredicate:predicate, options:.discreteAverage)
            { (_, result, error) in
                
                var resultCount = 0.0
                //NSLog("bbb")
                guard let result = result else {
                    print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                    //completion(resultCount)
                    return
                }
                if let sum = result.sumQuantity() {
                    resultCount = sum.doubleValue(for: HKUnit.count())
                }
                
                NSLog("heart beat \(resultCount)")
                
                /*DispatchQueue.main.async {
                 completion(resultCount)
                 }*/
            }
            healthStore.execute(query)
        } else{
            let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            /*        } else {
             // Fallback on earlier versions
             }*/
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: heartRateQuantityType, quantitySamplePredicate: predicate, options: .discreteAverage) { (_, result, error) in
                
                var resultCount = 0.0
                //NSLog("bbb")
                guard let result = result else {
                    print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                    //completion(resultCount)
                    return
                }
                if let sum = result.sumQuantity() {
                    resultCount = sum.doubleValue(for: HKUnit.count())
                }
                
                NSLog("heart beat \(resultCount)")
                
                /*DispatchQueue.main.async {
                 completion(resultCount)
                 }*/
            }
            healthStore.execute(query)
        }
    }
}
