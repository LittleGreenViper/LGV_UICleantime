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
import LGV_Cleantime
import LGV_UICleantime

/* ###################################################################################################################################### */
// MARK: - Main View Controller -
/* ###################################################################################################################################### */
/**
 */
class LGV_UICleantimeTestHarnessKeytagViewController: LGV_UICleantimeBaseViewController {
    /* ################################################################## */
    /**
     This is a switch that selectes whether the ring is open or closed.
    */
    @IBOutlet weak var isTopClosedSwitch: UISwitch?

    /* ################################################################## */
    /**
     The top closed label.
    */
    @IBOutlet weak var isTopClosedLabel: UILabel?

    /* ################################################################## */
    /**
     This will show a "busy throbber," while the images are being composited.
    */
    override func showThrobber() {
        super.showThrobber()
        isTopClosedSwitch?.isHidden = true
        isTopClosedLabel?.isHidden = true
    }
    
    /* ################################################################## */
    /**
     This will hide the "busy throbber," after the images were composited.
    */
    override func hideThrobber() {
        super.hideThrobber()
        isTopClosedSwitch?.isHidden = false
        isTopClosedLabel?.isHidden = false
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessKeytagViewController {
    /* ################################################################## */
    /**
     When the open/closed switch is changed, this is called.
     
     - parameter inSwitch: The switch.
    */
    @IBAction func switchChanged(_ inSwitch: UISwitch) {
        showThrobber()
        (cleantime as? LGV_UISingleCleantimeKeytagImageView)?.isRingClosed = inSwitch.isOn
    }
}
