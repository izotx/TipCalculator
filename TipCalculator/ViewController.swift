//
//  ViewController.swift
//  TipCalculator
//
//  Created by Janusz Chudzynski on 2/21/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit

class CustomButton:UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGrayColor().CGColor!
        self.layer.borderWidth = 1
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipWidget: TipView!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var billSlider: UISlider!
    var activeTextField:UITextField?
    var tipEngine = TipEngine()
    
    
    
    @IBOutlet weak var widgetView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        updateUI()
        self.widgetView.layer.borderColor = UIColor.whiteColor().CGColor!
        self.widgetView.layer.borderWidth = 1
    }

    override  func viewWillAppear(animated: Bool){
            super.viewWillAppear(animated)
            //check for share defualts
         self.registerForKeyboardNotifications()
        
        if let bill = SharedData.getBillData() {
            self.tipEngine.bill = bill
        }
        
        if let tip = SharedData.getTipData() {
            self.tipEngine.tipAmount = tip
        }
        
        if let tipPerc = SharedData.getTipPercentage() {
            self.tipEngine.tipPercentage = tipPerc
        }
        
    }

    
    
    func updateUI(){
        self.tipTextField.text = "\(TipEngine.getNiceText(tipEngine.updateTotals().tipPercent * 100  , precision: 0)!)%"
        self.billTextField.text = "$\(TipEngine.getNiceText(tipEngine.bill, precision: 2)!)"
 
        self.tipWidget.tipEngine = tipEngine
        self.tipSlider.value = Float(tipEngine.tipPercentage)
        self.billSlider.value = Float(tipEngine.bill)
        
        //save data
        SharedData.saveBillData(self.tipEngine.bill)
        SharedData.saveTipData(self.tipEngine.tipAmount)
        SharedData.saveTipPercentage(self.tipEngine.tipPercentage)
        
    }
    
    
    @IBAction func tipChanged(sender: AnyObject) {
        tipEngine.tipPercentage = Double(self.tipSlider.value)
        updateUI()
    }
   
    @IBAction func billChanged(sender: AnyObject) {
        tipEngine.bill = Double(self.billSlider.value)
        updateUI()
    }

    @IBAction func button20(sender: AnyObject) {
        tipEngine.tipPercentage = 0.2
         updateUI()
    }
    @IBAction func button18(sender: AnyObject) {
        tipEngine.tipPercentage = 0.18
         updateUI()
    }
 
    @IBAction func button15(sender: AnyObject) {
        tipEngine.tipPercentage = 0.15
        updateUI()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerForKeyboardNotifications() {
      
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = items as [AnyObject]
        doneToolbar.sizeToFit()
        if let txt  = self.activeTextField{
           txt.inputAccessoryView = doneToolbar
            
        }
    }
    
    func doneButtonAction()
    {
        if let txt  = self.activeTextField{
            txt.resignFirstResponder()
            //update sliders 
            
            if txt == self.billTextField {
                var bstring = (self.billTextField.text as NSString).substringFromIndex(1)
                var bill = (bstring as NSString).floatValue
                self.billSlider.value = bill
                self.billChanged(self)
            }
            if txt == self.tipTextField {
                var tip = (self.tipTextField.text as NSString).floatValue
                tip = tip/100.0
                self.tipSlider.value = tip
                self.tipChanged(self)
                println(self.tipSlider.value)
                
            }
        }
    }

    
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        let insets: UIEdgeInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, 0, 0)
        scrollView.contentInset = insets//contentInsets
        scrollView.scrollIndicatorInsets = insets//contentInsets
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        activeTextField = textField
        scrollView.scrollEnabled = true
        self.addDoneButtonOnKeyboard()
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        activeTextField = nil
        scrollView.scrollEnabled = false
    }
    

    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

