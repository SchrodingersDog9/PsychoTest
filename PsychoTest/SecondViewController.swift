//
//  SecondViewController.swift
//  PsychoTest
//
//  Created by 王翀 on 2017/10/27.
//  Copyright © 2017年 王翀. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Evaluate(_ sender: UIButton) {
        let detect : AnomalyDetection = AnomalyDetection(relativeCriterion: 0.01)
        detect.parameterEstimation(feature: "Dardick", data:[12,43,53,1,61,41,32,35])
        detect.Gaussian(feature: "Dardick", toBeExamined: 400)
        detect.MVG()
        
    }
    

}

