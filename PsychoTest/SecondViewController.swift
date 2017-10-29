//
//  SecondViewController.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/27.
//  Copyright © 2017年 王翀. All rights reserved.
//

import UIKit
import Foundation
import TKRadarChart

class SecondViewController: UIViewController, TKRadarChartDataSource, TKRadarChartDelegate, UITableViewDelegate {

    @IBOutlet weak var secondView: UIView!
    
    var myArray: [String]?

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myArray = ["Heart Rate", "Pace", "Skin Conductance", "Distance","Steps", "Sleep Quality",""]
        
        let w = secondView.bounds.width
        let chart = TKRadarChart(frame: CGRect(x: 0, y: 0, width: w, height: w))
        chart.configuration.radius = w/3
        chart.dataSource = self //as! TKRadarChartDataSource
        chart.delegate = self// as! TKRadarChartDelegate as! TKRadarChartDelegate
        chart.center = secondView.center
        chart.reloadData()
        secondView.addSubview(chart)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*    func Evaluate(_ sender: UIButton) {
        //let detect : AnomalyDetection = AnomalyDetectionafdadfasdfrelativeCriterion: 0.01, nil)
        //detect.parameterEstimation(feature: "Dardick", data:[12,43,53,1,61,41,32,35])
        //detect.Gaussian(feature: "Dardick", toBeExamined: 400)
        //detect.MVG()
        
    }*/
    

    func numberOfStepForRadarChart(_ radarChart: TKRadarChart) -> Int {
        return 20
    }
    func numberOfRowForRadarChart(_ radarChart: TKRadarChart) -> Int {
        return 6
    }
    func numberOfSectionForRadarChart(_ radarChart: TKRadarChart) -> Int {
        return 1
    }
    
    func titleOfRowForRadarChart(_ radarChart: TKRadarChart, row: Int) -> String {
        return myArray![row]
    }
    
    func valueOfSectionForRadarChart(withRow row: Int, section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(max(min(row + 1, 4), 3))
        } else {
            return 3
        }
    }
    
    
    
    
    func colorOfLineForRadarChart(_ radarChart: TKRadarChart) -> UIColor {
        return UIColor(red:0.337,  green:0.847,  blue:0.976, alpha:1)
    }
    
    func colorOfFillStepForRadarChart(_ radarChart: TKRadarChart, step: Int) -> UIColor {
        switch step{
        case 5,6,7,8,9,10: return UIColor(red:1,  green:1,  blue:1, alpha:0.3)
        case 11: return UIColor(red:0.545,  green:0.906,  blue:0.996, alpha:0.3)
        case 12: return UIColor(red:0.706,  green:0.929,  blue:0.988, alpha:0.2)
        case 13: return UIColor(red:0.831,  green:0.949,  blue:0.984, alpha:0.2)
        case 14: return UIColor(red:0.922,  green:0.976,  blue:0.988, alpha:0.2)
        case 15: return UIColor(red:0.922,  green:0.976,  blue:0.988, alpha:0.1)
        case 16: return UIColor(red:0.922,  green:0.976,  blue:0.988, alpha:0.1)
        case 17: return UIColor(red:0.922,  green:0.976,  blue:0.988, alpha:0.1)
            
            
        default: return UIColor.clear
        }
        
    }
    
    func colorOfSectionFillForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
        if section == 0 {
            return UIColor(red:1,  green:0.867,  blue:0.012, alpha:0.4)
        } else {
            return UIColor(red:0,  green:0.788,  blue:0.543, alpha:0.4)
        }
    }
    
    func colorOfSectionBorderForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
        if section == 0 {
            return UIColor(red:1,  green:0.867,  blue:0.012, alpha:1)
        } else {
            return UIColor(red:0,  green:0.788,  blue:0.543, alpha:1)
        }
    }
    

    
    
}

