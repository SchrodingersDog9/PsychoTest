//
//  DataExtraction.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/27.
//  Copyright © 2017年 王翀. All rights reserved.
//

import Foundation
import HealthKit
//import

class DailyStep{
    
    let healthStore = HKHealthStore()
    
    func getTodaysSteps(){
        //completion: @escaping (Double) -> Void) {
        
        if let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount){
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                
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
                
                NSLog("steps \(resultCount)")
                
                /*DispatchQueue.main.async {
                 completion(resultCount)
                 }*/
            }
            
            healthStore.execute(query)
        }
    }
}
