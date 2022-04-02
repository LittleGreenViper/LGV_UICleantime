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
 This provides a simple view, with a date picker, and a display medallion instance.
 */
class LGV_UICleantimeTestHarnessMedallionViewController: UIViewController, RVS_GeneralObserverSubTrackerProtocol {
    /* ################################################################## */
    /**
     This allows the tester to select a date.
    */
    @IBOutlet weak var dateSelector: UIDatePicker?
    
    /* ################################################################## */
    /**
     This displays a textual representation of the cleantime.
    */
    @IBOutlet weak var cleantimeReportLabel: LGV_UICleantimeDisplayTextLabel?

    /* ################################################################## */
    /**
     If on, then the view will display the latest tag earned.
    */
    @IBOutlet weak var includeTagsSwitch: UISwitch?

    /* ################################################################## */
    /**
     This is the cleantime medallion image.
    */
    @IBOutlet var cleantime: LGV_UISingleCleantimeMedallionImageView?
    
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
extension LGV_UICleantimeTestHarnessMedallionViewController {
    /* ################################################################## */
    /**
     When a new date is selected, it is given to the medallion image.
     
     - parameter inDatePicker: The picker instance.
    */
    @IBAction func newDate(_ inDatePicker: UIDatePicker) {
        LGV_UICleantimeTestHarnessAppDelegate.appDelegateInstance?.cleandate = inDatePicker.date
        let calculator = LGV_CleantimeDateCalc(startDate: inDatePicker.date, calendar: Calendar.current).cleanTime
        cleantimeReportLabel?.beginDate = inDatePicker.date
        cleantime?.totalDays = inDatePicker.date > Date() ? -1 : calculator.totalDays
        cleantime?.totalMonths = calculator.totalMonths
        cleantime?.setNeedsLayout()
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessMedallionViewController {
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
extension LGV_UICleantimeTestHarnessMedallionViewController: LGV_UICleantimeImageViewObserver {
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    func renderingComplete(view inImageView: LGV_UICleantimeImageViewBase) {
        print("Received rendering complete callback!")
    }
}
