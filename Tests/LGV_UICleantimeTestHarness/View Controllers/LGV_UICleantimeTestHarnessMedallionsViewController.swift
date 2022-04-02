/*
  © Copyright 2022, Little Green Viper Software Development LLC
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import RVS_Generic_Swift_Toolbox
import RVS_GeneralObserver
import LGV_Cleantime
import LGV_UICleantime

/* ###################################################################################################################################### */
// MARK: - Main View Controller -
/* ###################################################################################################################################### */
/**
 */
class LGV_UICleantimeTestHarnessMedallionsViewController: UIViewController, RVS_GeneralObserverSubTrackerProtocol {
    /* ################################################################## */
    /**
     This is the cleantime medallion image.
    */
    @IBOutlet var cleantime: LGV_UICleantimeMultipleMedallionsImageView!
    
    /* ################################################################## */
    /**
     This allows the tester to select a date.
    */
    @IBOutlet weak var dateSelector: UIDatePicker?
    
    /* ################################################################################################################################## */
    // MARK: RVS_GeneralObserverSubTrackerProtocol Conformance
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a UUID that is used internally
     */
    var uuid = UUID()

    /* ############################################################## */
    /**
     This stores our subscriptions.
     */
    var subscriptions: [RVS_GeneralObservableProtocol] = []
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessMedallionsViewController {
    /* ################################################################## */
    /**
     When a new date is selected, it is given to the medallion image.
     
     - parameter inDatePicker: The picker instance.
    */
    @IBAction func newDate(_ inDatePicker: UIDatePicker) {
        LGV_UICleantimeTestHarnessAppDelegate.appDelegateInstance?.cleandate = inDatePicker.date
        let calculator = LGV_CleantimeDateCalc(startDate: inDatePicker.date, calendar: Calendar.current).cleanTime
        cleantime?.totalDays = calculator.totalDays
        cleantime?.totalMonths = calculator.totalMonths
        cleantime?.setNeedsLayout()
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessMedallionsViewController {
    /* ################################################################## */
    /**
     Called just before the view appears. We use it to set the date picker date.
     
     - parameter inIsAnimated: True, if the appearance is to be animated.
    */
    override func viewWillAppear(_ inIsAnimated: Bool) {
        super.viewWillAppear(inIsAnimated)
        cleantime?.subscribe(self)
        if let dateSelector = dateSelector {
            dateSelector.date = LGV_UICleantimeTestHarnessAppDelegate.appDelegateInstance?.cleandate ?? Date()
            newDate(dateSelector)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: LGV_UICleantimeImageViewObserver Conformance
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessMedallionsViewController: LGV_UICleantimeImageViewObserver {
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    func renderingComplete(view inImageView: LGV_UICleantimeImageViewBase) {
        print("Received rendering complete callback!")
    }
}
