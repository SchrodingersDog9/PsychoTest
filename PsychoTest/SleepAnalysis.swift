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
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let startOfNextDay = Calendar.current.startOfDay(for: Date(timeInterval : 86400, since : now))
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: startOfNextDay, options: .strictStartDate)
            
            let query = HKSampleQuery(sampleType: sleepAnalysisType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) {(query, result, error) in
                
                guard let result = result else {
                    print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                    //completion(resultCount)
                    return
                }
                
                //let unitFlags : UnsignedInteger = NSCalendar.Component.Year|NSCalendar.Component.month|NSCalendar.Component.day|NSCalendar.Component.hour|NSCalendar.Component.minute|NSCalendar.Component.second
                
                var sleepAccumulator : Double = 0
                var inBedAccumulator : Double = 0
                
                for item in result {
                    if let sample = item as? HKCategorySample {
                        let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        //print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        if value == "Asleep"{
                            //var diffDateComponents = NSCalendar.current.dateComponents([NSCalendar.Components.year,NSCalendar.Component.month,NSCalendar.Component.day,NSCalendar.Component.hour,NSCalendar.Component.minute,NSCalendar.Component.second], from: sample.startDate, to: sample.endDate, options: NSCalendar.Options.init(rawValue: 0))
                            
                            /*let calendar = NSCalendar.current
                             let components = NSCalendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: sample.startDate)
                             let now = NSCalendar.currentCalendar().dateWithEra(1, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second, nanosecond: components.nanosecond)!
                             let newYears = NSCalendar.currentCalendar().dateWithEra(1, year: components.year, month: 12, day: 31, hour: 01, minute: 00, second: 00, nanosecond: 00)!
                             
                             
                             let units: NSCalendar.Unit = [.day, .month, .year, .hour, .minute, .second]
                             let difference = NSCalendar.current.dateComponents(units, from: sample.startDate, to: sample.endDate, options: [])*/
                            
                            inBedAccumulator = inBedAccumulator + sample.endDate.timeIntervalSince(sample.startDate)
                        }
                        if value == "InBed"{
                            sleepAccumulator = sleepAccumulator + sample.endDate.timeIntervalSince(sample.startDate)
                        }
                    }
                }
                NSLog("sleep time / in bed time = \(sleepAccumulator/(inBedAccumulator+sleepAccumulator))")
                
                //DispatchQueue.main.async {
                //    completion(resultCount)
                //}
            }
            
            healthStore.execute(query)
        }
    }
    
}
