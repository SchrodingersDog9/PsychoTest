//
//  FirstViewController.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/27.
//  Copyright © 2017年 王翀. All rights reserved.
//

import UIKit
import HealthKit

class FirstViewController: UIViewController {
    let steps : DailyStep = DailyStep()
    let heart : HeartRate = HeartRate()
    let sleep : SleepAnalysis = SleepAnalysis()
    
    /*override func viewDidLoad() {
     super.viewDidLoad()
     // Do any additional setup after loading the view, typically from a nib.
     }*/
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
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
        
    }
    
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

