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
     The scroller, containing the display.
    */
    @IBOutlet weak var scrollView: UIScrollView?

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

    /* ################################################################################################################################## */
    // MARK: Base Class Overrides (In Main Declaration)
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when the images have completed rendering.
     
     - parameter view: The completed UIImageView
     */
    override func renderingComplete(view inImageView: LGV_UICleantimeImageViewBase) {
        super.renderingComplete(view: inImageView)
        guard let contentSize = scrollView?.contentSize,
              0 < contentSize.height
        else {
            scrollView?.zoomScale = 1.0
            return
        }
        
        // This makes sure that the scroller goes to the top of the matrix, if it is resized.
        let intW = inImageView.intrinsicContentSize.width
        let intH = inImageView.intrinsicContentSize.height
        let dispW = inImageView.bounds.size.width
        let scale = intW / dispW
        let differenceInHeight = max(0, (contentSize.height - (intH / scale)) / 2)
        scrollView?.contentOffset.y = differenceInHeight
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
     Called after the view is loaded, the first time.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        (cleantime as? LGV_UIMultipleCleantimeKeytagImageView)?.keytagsAreAVerticalStrip = false
    }

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

/* ###################################################################################################################################### */
// MARK: UIScrollViewDelegate Conformance
/* ###################################################################################################################################### */
extension LGV_UICleantimeTestHarnessKeytagsViewController: UIScrollViewDelegate {
    /* ################################################################## */
    /**
     This simply sets the image view as a pinch to zoom target.
     */
    func viewForZooming(in: UIScrollView) -> UIView? { cleantime }
}
