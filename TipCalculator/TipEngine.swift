//
//  TipEngine.swift
//  TipCalculator
//
//  Created by Janusz Chudzynski on 2/23/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
class TipEngine {
    var total:Double = 0.0 
    var bill:Double = 10.0 {didSet {
        self.updateTotals()
        }
    }

    var tipAmount:Double = 0.0
    var tipPercentage:Double = 0.15 {didSet {
            self.updateTotals()
        }
    }
    
     
    class func getNiceText(n:Double,precision:Int)->String?{
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = precision
         return formatter.stringFromNumber(n)
    }

    
    func updateTotals()->(tipPercent:Double, tipAmount:Double, totalAmount:Double){
        self.tipAmount = bill * tipPercentage
        total = bill + tipAmount
        
        return (self.tipPercentage, self.tipAmount, self.total)
    }
    
    
}