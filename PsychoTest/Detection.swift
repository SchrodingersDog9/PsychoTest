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
        self.probs = Dictionary()
        self.record = vector
        self.qualify = Dictionary()
    }
    
    private let epsilon : Double!
    private let record : [String : Double]
    private var qualify : [String: Bool]
    public var means : [String : Double]
    public var stds : [String : Double]
    public var probs : [String : Double]
    
    
    func parameterEstimation(feature name : String, data vec : [Double]) -> Void{
        var mean = 0.0
        let length:Double = Double(vec.count)
        for element in vec{
            mean = element + mean
        }
        mean = mean/length
        
        var std = 0.0
        for element in vec{
            std = (element-mean) * (element-mean) + std
            //NSLog("std : \(std)")
        }
        std = sqrt(std/(length-1))
        
        means[name] = mean
        stds[name] = std
    }
    
    func zScore(feature name : String, toBeExamined value : Double) -> Double {
        return ((value-means[name]!)/(stds[name]!))
    }
    
    func Gaussian() -> Void{
        for element in record{
            probs[element.key] = ((1/(sqrt(2*Double.pi)))*exp((-pow(zScore(feature: element.key, toBeExamined: element.value),2)/2)))
            qualify[element.key] = (probs[element.key]!>epsilon)
        }
    }
    
    func MVG() -> Bool {
        var joint : Double = 1.0
        for element in probs{
            joint = joint * element.value
        }
        if joint < epsilon{
            //NSLog("Alert! (\(joint) < \(epsilon!))")
            return true
        }
        return false
    }
    
    
    
}
