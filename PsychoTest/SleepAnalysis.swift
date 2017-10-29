//
//  SleepAnalysis.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/28.
//  Copyright © 2017年 王翀. All rights reserved.
//

import Foundation
import HealthKit

class SleepAnalysis{
    let healthStore = HKHealthStore()
    var timeInBed = 0
    
    func getTodaysSleep(){
        //completion: @escaping (Double) -> Void)
        if let sleepAnalysisType = HKCategoryType.categoryType(forIdentifier:HKCategoryTypeIdentifier.sleepAnalysis){
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            /*let now = Date()
             let startOfDay = Calendar.current.startOfDay(for: now)
             let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)*/
            
            let query = HKSampleQuery(sampleType: sleepAnalysisType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) {(query, result, error) in
                
                guard let result = result else {
                    print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                    //completion(resultCount)
                    return
                }
                
                let unitFlags : UnsignedInteger = NSCalendar.Unit.Year|NSCalendar.Unit.month|NSCalendar.Unit.day|NSCalendar.Unit.hour|NSCalendar.Unit.minute|NSCalendar.Unit.second
                
                for item in result {
                    if let sample = item as? HKCategorySample {
                        let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "Asleep" : "InBed"
                        //print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        if value == "InBed"{
                            var diffDateComponents = NSCalendar.current.dateComponents([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from: sample.startDate, to: sample.endDate, options: NSCalendar.Options.init(rawValue: 0))
                            

                        }
                    }
                }
                
                
                //DispatchQueue.main.async {
                //    completion(resultCount)
                //}
            }
            
            healthStore.execute(query)
        }
    }
    
}
