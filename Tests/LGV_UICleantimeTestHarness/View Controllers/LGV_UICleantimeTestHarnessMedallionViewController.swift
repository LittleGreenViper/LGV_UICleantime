/*
  © Copyright 2022-2026, Little Green Viper Software Development LLC
 
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
import LGV_Cleantime
import LGV_UICleantime

/* ###################################################################################################################################### */
// MARK: - Single Medallion View Controller -
/* ###################################################################################################################################### */
/**
 This provides a simple view, with a date picker, and a display medallion instance.
 */
class LGV_UICleantimeTestHarnessMedallionViewController: LGV_UICleantimeBaseViewController {    
    /* ################################################################## */
    /**
     This displays a textual representation of the cleantime.
    */
    @IBOutlet weak var cleantimeReportLabel: LGV_UICleantimeDisplayTextLabel?

    /* ################################################################## */
    /**
     The text label for the switch
    */
    @IBOutlet weak var shortLabelLabel: UILabel?
    
    /* ################################################################## */
    /**
     If on, then the text report will be the short version.
    */
    @IBOutlet weak var shortLabelSwitch: UISwitch?
    
    /* ################################################################## */
    /**
     This will show a "busy throbber," while the images are being composited.
    */
    override func showThrobber() {
        super.showThrobber()
        cleantimeReportLabel?.isHidden = true
    }
    
    /* ################################################################## */
    /**
     This will hide the "busy throbber," after the images were composited.
    */
    override func hideThrobber() {
        super.hideThrobber()
        cleantimeReportLabel?.isHidden = false
    }
    
    /* ################################################################## */
    /**
     When a new date is selected, it is used to fill the cleantime report label.
     
     - parameter inDatePicker: The picker instance.
    */
    override func newDate(_ inDatePicker: UIDatePicker) {
        cleantimeReportLabel?.beginDate = inDatePicker.date
        super.newDate(inDatePicker)
    }
    
    /* ################################################################## */
    /**
     The short label switch was hit.
    */
    @IBAction func shortLabelSwitchHit(_ inSwitch: UISwitch) {
        cleantimeReportLabel?.isShort = inSwitch.isOn
    }
}
