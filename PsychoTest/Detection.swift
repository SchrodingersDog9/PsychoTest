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
    init(relativeCriterion epsilon : Double){
        self.epsilon = epsilon
        self.stds = Dictionary()
        self.means = Dictionary()
        self.probs = Dictionary()
    }
    private let epsilon : Double!
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
    
    func Gaussian(feature name : String, toBeExamined value : Double) -> Void{
        probs[name] = ((1/(sqrt(2*Double.pi)))*exp((-pow(zScore(feature: name, toBeExamined: value),2)/2)))
    }
    
    func MVG() -> Void{
        var joint : Double = 1.0
        for element in probs{
            joint = joint * element.value
        }
        if joint < epsilon{
            NSLog("Alert! (\(joint) < \(epsilon!))")
        }
    }
    
    
    
    
    
}
