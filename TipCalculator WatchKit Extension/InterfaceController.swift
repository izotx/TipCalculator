//
//  InterfaceController.swift
//  TipCalculator WatchKit Extension
//
//  Created by Janusz Chudzynski on 2/21/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    var tipEngine:TipEngine?
    
    @IBOutlet weak var tipStepper: WKInterfaceSlider!
    @IBOutlet weak var amountStepper: WKInterfaceSlider!
    @IBOutlet weak var amountLabel: WKInterfaceLabel!
    @IBOutlet weak var totalLabel: WKInterfaceLabel!
    @IBOutlet weak var tipAmountLabel: WKInterfaceLabel!

    @IBOutlet weak var tipPercentageLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
          }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        tipEngine = TipEngine()
        tipStepper.setValue(Float(self.tipEngine!.tipPercentage))
        amountStepper.setValue(Float(self.tipEngine!.bill ))
        // Configure interface objects here.

    
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func billStepperChanged(value: Float) {
        tipEngine!.bill = Double(Int(value))
        updateUI()
    }
    
    @IBAction func tipStepperChanged(value: Float) {
       tipEngine!.tipAmount = Double(Int(value))
        updateUI()
    }
    @IBAction func tip20() {
        tipEngine!.tipPercentage = 0.2
        updateUI()
    }
    
    @IBAction func Tip15() {
        tipEngine!.tipPercentage = 0.15
        updateUI()
    
    }
    
    @IBAction func tip18() {
        tipEngine!.tipPercentage = 0.18
        updateUI()
        
    }
    
    func updateUI(){
        self.tipAmountLabel.setText("\(TipEngine.getNiceText(tipEngine!.updateTotals().tipPercent * 100  , precision: 0)!)%")

        self.amountLabel.setText("$\(TipEngine.getNiceText(tipEngine!.bill, precision: 2)!)")
        self.tipPercentageLabel.setText("\(self.tipEngine!.tipPercentage * 100 )%")
        
        

    }
    
}
