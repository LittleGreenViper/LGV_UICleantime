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
class LGV_UICleantimeTestHarnessKeytagsViewController: LGV_UICleantimeBaseViewController {
    /* ################################################################## */
    /**
     This allows the user to switch between horizontal arrangement, and vertical arrangement.
    */
    @IBOutlet weak var horizontalVerticalSwitch: UISwitch?

    /* ################################################################## */
    /**
     The horizontal side label.
    */
    @IBOutlet weak var horizontalSwitchLabel: UILabel?

    /* ################################################################## */
    /**
     The vertical side label.
    */
    @IBOutlet weak var verticalSwitchLabel: UILabel?

    /* ################################################################## */
    /**
     This will show a "busy throbber," while the images are being composited.
    */
    override func showThrobber() {
        super.showThrobber()
        horizontalVerticalSwitch?.isHidden = true
        horizontalSwitchLabel?.isHidden = true
        verticalSwitchLabel?.isHidden = true
    }
    
    /* ################################################################## */
    /**
     This will hide the "busy throbber," after the images were composited.
    */
    override func hideThrobber() {
        super.hideThrobber()
        horizontalVerticalSwitch?.isHidden = false
        horizontalSwitchLabel?.isHidden = false
        verticalSwitchLabel?.isHidden = false
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessKeytagsViewController {
    /* ################################################################## */
    /**
     Called when the orientation switch changes.
     
     - parameter inSwitch: The switch instance.
    */
    @IBAction func orientationSwitchChanged(_ inSwitch: UISwitch) {
        showThrobber()
        (cleantime as? LGV_UIMultipleCleantimeKeytagImageView)?.keytagsAreAVerticalStrip = inSwitch.isOn
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessKeytagsViewController {
    /* ################################################################## */
    /**
     Called just before the view appears. We use it to set the date picker date.
     
     - parameter inIsAnimated: True, if the appearance is to be animated.
    */
    override func viewWillAppear(_ inIsAnimated: Bool) {
        super.viewWillAppear(inIsAnimated)
        horizontalVerticalSwitch?.isOn = (cleantime as? LGV_UIMultipleCleantimeKeytagImageView)?.keytagsAreAVerticalStrip ?? false
    }
}
