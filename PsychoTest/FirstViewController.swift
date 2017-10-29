//
//  FirstViewController.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/27.
//  Copyright © 2017年 王翀. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import Foundation

class FirstViewController: UIViewController {
    let steps : DailyStep = DailyStep()
    let heart : HeartRate = HeartRate()
    let sleep : SleepAnalysis = SleepAnalysis()
    let pedo = CMPedometer()
    let healthStore = HKHealthStore()
    let m = 6
    
    /*override func viewDidLoad() {
     super.viewDidLoad()
     // Do any additional setup after loading the view, typically from a nib.
     }*/
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
            if (launchedBefore) {  //!
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
                    
                    //------------------fetch heart rate------------------
                    let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
                    
                    /* let now = Date()
                     let startOfDay = Calendar.current.startOfDay(for: now)
                     let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)*/
                    
                    let query2 = HKStatisticsQuery(quantityType: heartRateQuantityType, quantitySamplePredicate: predicate, options: .discreteAverage) { (_, result, error) in
                        
                        var resultCount = 0.0
                        
                        guard let result = result else {
                            print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                            //completion(resultCount)
                            return
                        }
                        
                        if let sum = result.sumQuantity() {
                            resultCount = sum.doubleValue(for: HKUnit.count())
                        }
                        
                        dataOfToday[4] = resultCount;
                        //NSLog("skin: \(resultCount)")
                        
                        /*DispatchQueue.main.async {
                         completion(resultCount)
                         }*/
                    }
                    
                    //self.healthStore.execute(query)
                    self.healthStore.execute(query2)
                    
                    //-------------------fetch sleep analysis----------------
                    if let sleepAnalysisType = HKCategoryType.categoryType(forIdentifier:HKCategoryTypeIdentifier.sleepAnalysis){
                        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)


                    let query3 = HKSampleQuery(sampleType: sleepAnalysisType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) {(query, result, error) in
                        
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
                        
                        dataOfToday[5] = (sleepAccumulator/(inBedAccumulator+sleepAccumulator));
                        //NSLog("sleep time / in bed time = \(sleepAccumulator/(inBedAccumulator+sleepAccumulator))")
                        
                        //DispatchQueue.main.async {
                        //    completion(resultCount)
                        //}
                    }
                    
                        self.healthStore.execute(query3)}
                

/*                    //------------------fetch resting heart rate------------------
                    let restingHeartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
                    
                    /* let now = Date()
                     let startOfDay = Calendar.current.startOfDay(for: now)
                     let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)*/
                    
                    let query3 = HKStatisticsQuery(quantityType: restingHeartRateQuantityType, quantitySamplePredicate: predicate, options: .discreteAverage) { (_, result, error) in
                        
                        var resultCount = 0.0
                        
                        guard let result = result else {
                            print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                            //completion(resultCount)
                            return
                        }
                        
                        if let sum = result.sumQuantity() {
                            resultCount = sum.doubleValue(for: HKUnit.count())
                        }
                        
                        dataOfToday[5] = resultCount;
                        //NSLog("skin: \(resultCount)")
                        
                        /*DispatchQueue.main.async {
                         completion(resultCount)
                         }*/
                    }
                    
                    //self.healthStore.execute(query)
                    self.healthStore.execute(query3)
                    
                    //storedData.append(dataOfToday);*/
                    
                    userDefaults.set(num+1, forKey: "num");
                    for i in 1...num {
                        userDefaults.set(storedData[i], forKey: String(i));
                    }
                    userDefaults.set(dataOfToday, forKey: String(num+1));
                    
                    
                    var alertNum = 0;
                    
                    for i in 1...self.m {
                        var dict = [String : Double]()
                        for j in 1...num {
                            dict[String(j)] = storedData[j][i]
                        }
                        var det = AnomalyDetection(relativeCriterion: 0.10, record: dict)
                        if (det.MVG()) {alertNum += 1;}
                    }
                    if (alertNum >= 3)  {NSLog("ALERT!!!!!!");}
                    
                    var avgNumStep = 0.0;
                    var avgPace = 0.0;
                    var avgDist = 0.0;
                    var avgSkin = 0.0;
                    var avgHR = 0.0
                    var avgSleep = 0.0
                    //var avgRestHR = 0.0
                    for i in 1...num {
                        avgNumStep += storedData[i][0]
                        avgPace += storedData[i][1]
                        avgDist += storedData[i][2]
                        avgSkin += storedData[i][3]
                        avgHR += storedData[i][4]
                        avgSleep += storedData[i][5]
                        //avgRestHR += storedData[i][5]
                    }
                    userDefaults.set((avgNumStep + dataOfToday[0]) / Double(num + 1), forKey: String("avgNumStep"));
                    userDefaults.set((avgPace + dataOfToday[1]) / Double(num + 1), forKey: String("avgPace"));
                    userDefaults.set((avgDist + dataOfToday[2]) / Double(num + 1), forKey: String("avgDist"));
                    userDefaults.set((avgSkin + dataOfToday[3]) / Double(num + 1), forKey: String("avgSkin"));
                    userDefaults.set((avgHR + dataOfToday[4]) / Double(num + 1), forKey: String("avgHR"));
                    userDefaults.set((avgSleep + dataOfToday[5]) / Double(num + 1), forKey: String("avgSleep"));
                    //userDefaults.set((avgRestHR + dataOfToday[5]) / Double(num + 1), forKey: String("avgRestHR"));
                    
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
    
    
    
/*    override func viewDidLoad() {
        super.viewDidLoad()
        
        let typestoRead = Set(
            [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
             HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
            ]
        )
        
        if #available(iOS 11.0, *) {
            let typestoShare = Set(
                [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                 HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
                 HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                 HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!
                ]
            )
            
            healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
                if success == false {
                    NSLog(" Display not allowed")
                }
            }
        } else {
            // Fallback on earlier versions
            let typestoShare = Set(
                [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                 HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
                 HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
                ]
            )
            
            healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
                if success == false {
                    NSLog(" Display not allowed")
                }
            }

        }
        
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
        
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func printData(_ sender: UIButton) {
        
        steps.getTodaysSteps()
        sleep.getTodaysSleep()
        heart.getTodaysSteps()
        
    }
    
    
    
}

