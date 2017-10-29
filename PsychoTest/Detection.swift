//
//  Detection.swift
//  ArchHack2017
//
//  Created by 李书豪 on 28/10/2017.
//  Copyright © 2017 SchrodingersDog. All rights reserved.
//

import Foundation
import Accelerate

class AnomalyDetection{
    init(relativeCriterion epsilon : Double, record vector : [String : Double]){
        self.epsilon = epsilon
        self.stds = Dictionary()
        self.means = Dictionary()
        self.zScores = Dictionary()
        self.record = vector
        self.qualify = Dictionary()
    }
    
    private let epsilon : Double!
    private let record : [String : Double]
    public var qualify : [String: Bool]
    public var means : [String : Double]
    public var stds : [String : Double]
    public var zScores : [String : Double]
    
    
    func parameterEstimation() -> Void{
        for elements in record{
            var mean = 0.0
            let length:Double = Double(record.count)
            for element in record{
                mean = element.value + mean
            }
            means[elements.key] = mean/length
            
            var std = 0.0
            for element in record{
                std = (element.value-mean) * (element.value-mean) + std
                //NSLog("std : \(std)")
            }
            std = sqrt(std/(length-1))
            
            stds[elements.key] = std
        }
    }
    
    func zScore() -> Void {
        for element in record{
            zScores[element.key] = ((element.value-means[element.key]!)/(stds[element.key]!))
            qualify[element.key] = (zScores[element.key]!>epsilon)
        }
    }
    
    /*func Gaussian() -> Void{
     for element in record{
     probs[element.key] = ((1/(sqrt(2*Double.pi)))*exp((-pow(zScore(feature: element.key, toBeExamined: element.value),2)/2)))
     qualify[element.key] = (probs[element.key]!>epsilon)
     }
     }*/
    
    func MVG() -> Bool {
        var joint : Double = 1.0
        for element in zScores{
            joint = joint * element.value
        }
        if joint > epsilon{
            //NSLog("Alert! (\(joint) < \(epsilon!))")
            return true
        }
        return false
    }
    
    
    
}
