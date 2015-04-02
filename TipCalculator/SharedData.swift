//
//  SharedData.swift
//  tipCalculator
//
//  Created by Janusz Chudzynski on 4/2/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation

class SharedData{

    
    let billKey = "bill"
    let tipKey = "tip"
    let tipPercKey = "tipPerc"
    
    let userDefaults = NSUserDefaults(suiteName: "group.tipAppCalculator")
    
    class func getBillData()->Double?{
        let sharedData = SharedData()
        return sharedData.userDefaults?.doubleForKey(sharedData.billKey)
    }
    
    class func getTipData()->Double?{
       let sharedData = SharedData()
        return sharedData.userDefaults?.doubleForKey(sharedData.tipKey)
    }
    
    class func saveBillData(bill:Double){
        let sharedData = SharedData()
        sharedData.userDefaults!.setDouble(bill, forKey: sharedData.billKey)
    }
    
    class func saveTipData(tip:Double){
        let sharedData = SharedData()
        sharedData.userDefaults!.setDouble(tip, forKey: sharedData.tipKey)
    }
    
    
    class func saveTipPercentage(tip:Double){
        let sharedData = SharedData()
        sharedData.userDefaults!.setDouble(tip, forKey: sharedData.tipPercKey)
    
    }
    
    class func getTipPercentage()->Double?{
        let sharedData = SharedData()
        return sharedData.userDefaults?.doubleForKey(sharedData.tipPercKey)
    }
    
    
}