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
    
    
    //menu buttons
    
    @IBAction func eraseContent() {
        self.tipEngine!.bill = 0
        self.tipEngine!.tipAmount = 0
        self.tipEngine!.tipPercentage = 0
        
        self.updateUI()
    }
    
    @IBAction func set1Interval() {
        self.amountStepper.setNumberOfSteps(1000)
    }
    
    @IBAction func set5Interval() {
        self.amountStepper.setNumberOfSteps(200)
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        tipEngine = TipEngine()
        
        if let te = tipEngine {
            if let bill = SharedData.getBillData() {
                self.tipEngine!.bill = bill
            }
            
            if let tip = SharedData.getTipData() {
                self.tipEngine!.tipAmount = tip
            }
            
            if let tipPerc = SharedData.getTipPercentage() {
                self.tipEngine!.tipPercentage = tipPerc
            }
            
        }
        self.updateUI()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func billStepperChanged(value: Float) {
        if tipEngine!.bill < Double(value)
        {
            tipEngine!.bill = Double(ceil(value))
        }
        else{
           tipEngine!.bill = Double(floor(value))
        }


        updateUI()
    }
    
    @IBAction func tipStepperChanged(value: Float) {
        
        tipEngine!.tipPercentage = Double(Int(value))/100.0
        
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
        tipStepper.setValue(Float(self.tipEngine!.tipPercentage * 100))
        amountStepper.setValue(Float(self.tipEngine!.bill ))
        
        self.tipAmountLabel.setText("$\(TipEngine.getNiceText(tipEngine!.updateTotals().tipAmount  , precision: 2)!)")
        self.amountLabel.setText("$\(TipEngine.getNiceText(tipEngine!.bill, precision: 2)!)")
        self.totalLabel.setText("$\(TipEngine.getNiceText(tipEngine!.total, precision: 2)!)")
        self.tipPercentageLabel.setText("\(self.tipEngine!.tipPercentage * 100)%")
        
        if let te = self.tipEngine {
            SharedData.saveBillData(te.bill)
            SharedData.saveTipData(te.tipAmount)
            SharedData.saveTipPercentage(te.tipPercentage)
        }
        
        
        
    }
    
}
